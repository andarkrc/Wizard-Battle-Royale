// General buffer types
#macro STRING buffer_string
#macro INT buffer_s32
#macro FLOAT buffer_f32
#macro DOUBLE buffer_f64
#macro LONG buffer_u64
// Specific buffer types
#macro BOOL buffer_bool // [0 -> 1]

#macro F16 buffer_f16
#macro F32 buffer_f32
#macro F64 buffer_f64

#macro S8  buffer_s8  // [-128 -> 127]
#macro S16 buffer_s16 // [-32768 -> 32767]
#macro S32 buffer_s32 // [-2147483648 -> 2147483647]

#macro U8  buffer_u8  // [0 -> 255]
#macro U16 buffer_u16 // [0 -> 65,535]
#macro U32 buffer_u32 // [0 -> 4,294,967,295]
#macro U64 buffer_u64 // [0 -> 18,446,744,073,709,551,615]

global.server_ip = "127.0.0.1";
global.server_port = 6000;
global.connection_type = "";

global.networking_version = "Wizard Battle Royale v0.1";

enum NWTarget {
	SERVER = -100,
	HOST = -1,
	ALL = -10,
	OTHER = -9
};

/// @desc Creates a new packet.
/// @desc SHOULD ONLY BE USED BY CLIENTS.
/// @arg {Real} target
/// @arg {Real} type
/// @arg {Struct} data
function packet_create(target, type, data = {})
{
	var packet = buffer_create(128, buffer_grow, 1);
	buffer_seek(packet, buffer_seek_start, 0);
	
	buffer_write(packet, STRING, global.networking_version);
	buffer_write(packet, S32, target);
	packet_serialize_data(packet, type, data);
	
	return packet;
}

/// @desc Sends a packet.
/// @desc THE PACKET WILL BE DELETED.
/// @arg {Id.Socket} socket
/// @arg {Id.Buffer} packet
function packet_send(socket, packet)
{
	buffer_seek(packet, buffer_seek_end, 0);
	var sent = network_send_packet(socket, packet, buffer_tell(packet));
	buffer_delete(packet);
}

/// @desc Reads data from a packet from a client and returns a struct containing the data.
/// @arg {Id.Buffer} packet
function packet_parse_client_packet(packet)
{
	buffer_seek(packet, buffer_seek_start, 0);
	
	var version = buffer_read(packet, STRING);
	var target = buffer_read(packet, S32);
	var data = packet_deserialize_data(packet);
	
	return data;
}

/// @desc Reads data from a packet from the server and returns a struct containing the data.
/// @arg {Id.Buffer} packet
function packet_parse_server_packet(packet)
{
	buffer_seek(packet, buffer_seek_start, 0);
	
	var version = buffer_read(packet, STRING);
	var sender = buffer_read(packet, S32);
	var is_host = buffer_read(packet, BOOL);
	var data = packet_deserialize_data(packet);
	
	struct_set(data, "sender_id", sender);
	struct_set(data, "sender_is_host", is_host);
	
	return data;
}

/// @desc Creates a new packet.
/// @desc SHOULD ONLY BE USED BY SERVER.
/// @arg {Real} sender
/// @arg {Bool} is_host
/// @arg {Real} type
/// @arg {Struct} data
function packet_create_server(sender, is_host, type, data = {})
{
	var packet = buffer_create(128, buffer_grow, 1);
	buffer_seek(packet, buffer_seek_start, 0);
	
	buffer_write(packet, STRING, global.networking_version);
	buffer_write(packet, S32, sender);
	buffer_write(packet, BOOL, is_host);
	
	packet_serialize_data(packet, type, data);
	
	return packet;
}

enum PacketDataType {
	INT32,
	UINT64,
	FLOAT32,
	FLOAT64,
	STR,
	ARRAY,
	STRUCT,
	BOOLEAN,
}

/// @desc Writes data into the packet.
/// @desc Will write at the position of the buffer cursor.
/// @arg {Id.Buffer} packet
/// @arg {Real} type
/// @arg {Struct} data
function packet_serialize_data(packet, type, data)
{
	buffer_write(packet, S32, type);
	var names = struct_get_names(data);
	for (var i = 0; i < array_length(names); i++) {
		var name = names[i];
		if (name == "sender_id" || name == "type" || name == "sender_is_host") continue;
		
		var value = data[$ name];
		
		buffer_write(packet, STRING, name);
		
		switch (typeof(value)) {
			case "int32" :
				buffer_write(packet, S32, PacketDataType.INT32);
				buffer_write(packet, S32, value);
				break;
			
			case "int64" :
				buffer_write(packet, S32, PacketDataType.UINT64);
				buffer_write(packet, U64, value);
				break;
			
			case "number":
				if (floor(value) == value) {
					if (value > 2_147_483_647) {
						buffer_write(packet, S32, PacketDataType.UINT64);
						buffer_write(packet, U64, value);
					} else {
						buffer_write(packet, S32, PacketDataType.INT32);
						buffer_write(packet, S32, value);
					}
				} else {
					buffer_write(packet, S32, PacketDataType.FLOAT64);
					buffer_write(packet, F64, value);
				}
				break;
			
			case "bool":
				buffer_write(packet, S32, PacketDataType.BOOLEAN);
				buffer_write(packet, BOOL, value);
				break;
			
			case "string":
				buffer_write(packet, S32, PacketDataType.STR);
				buffer_write(packet, STRING, value);
				break;
			
			default:
				show_debug_message($"Unknown type {typeof(value)} for packet of type {type} at {name}");
				break;
		}
	}
	
	buffer_write(packet, STRING, "EOD");
}

/// @desc Reads data from the packet into a struct.
/// @desc Will read from the position of the buffer cursor.
/// @arg {Id.Buffer} packet
function packet_deserialize_data(packet)
{
	var data = {};
	
	var packet_type = buffer_read(packet, S32);
	
	var name, type, value;
	
	while (true) {
		name = buffer_read(packet, STRING);
		if (name == "EOD") {
			break;
		}
		type = buffer_read(packet, S32);
		
		switch (type) {
			case PacketDataType.STR :
				value = buffer_read(packet, STRING);
				break;
			
			case PacketDataType.BOOLEAN :
				value = buffer_read(packet, BOOL);
				break;
			
			case PacketDataType.FLOAT64 :
				value = buffer_read(packet, F64);
				break;
			
			case PacketDataType.FLOAT32 :
				value = buffer_read(packet, F32);
				break;
			
			case PacketDataType.INT32 :
				value = buffer_read(packet, S32);
				break;
			
			case PacketDataType.UINT64 :
				value = buffer_read(packet, U64);
				break;
			
			default:
				value = undefined;
				show_debug_message($"Unknown type at parsing packet of type {packet_type}: {type} at {name}")
				break;
		}
		if (name == "") {
			show_debug_message($"EMPTY NAME FOR PARSING PACKET OF TYPE {packet_type}");
		}
		if (!struct_exists(data, name)) {
			struct_set(data, name, value);
		}
	}
	
	struct_set(data, "type", packet_type);
	
	return data;
}


/// @desc Creates a new packet with the same data, but server packet header.
/// @arg {Id.Buffer} packet
/// @arg {Real} sender
/// @arg {Bool} is_host
/// @arg {Bool} should_free
function packet_change_client_to_server(packet, sender, is_host, should_free = false)
{
	var new_packet = buffer_create(128, buffer_grow, 1);
	buffer_seek(new_packet, buffer_seek_start, 0);
	
	buffer_write(new_packet, STRING, global.networking_version);
	buffer_write(new_packet, S32, sender);
	buffer_write(new_packet, BOOL, is_host);
	var dst_offset = buffer_tell(new_packet);
	
	buffer_seek(packet, buffer_seek_start, 0);
	buffer_read(packet, STRING);
	buffer_read(packet, S32);
	var src_start = buffer_tell(packet);
	buffer_seek(packet, buffer_seek_end, 0);
	var src_end = buffer_tell(packet);
	
	buffer_copy(packet, src_start, src_end - src_start, new_packet, dst_offset);

	if (should_free) {
		buffer_delete(packet);
	}
	
	return new_packet;
}

/// @desc Sends a packet to multiple sockets.
/// @desc THE PACKET WILL BE DELETED.
/// @arg {Array<Id.Socket>} sockets
/// @arg {Id.Buffer} packet
function packet_send_multiple(sockets, packet)
{
	buffer_seek(packet, buffer_seek_end, 0);
	var len = buffer_tell(packet);
	
	for (var i = 0; i < array_length(sockets); i++) {
		network_send_packet(sockets[i], packet, len);
	}
	
	buffer_delete(packet);
}

function packet_send_multiple_except(sockets, packet, except)
{
	buffer_seek(packet, buffer_seek_end, 0);
	var len = buffer_tell(packet);
	
	for (var i = 0; i < array_length(sockets); i++) {
		if (sockets[i] == except) continue;
		network_send_packet(sockets[i], packet, len);
	}

	buffer_delete(packet);
}

function packet_send_multiple_except_list(sockets, packet, except)
{
	buffer_seek(packet, buffer_seek_end, 0);
	var len = buffer_tell(packet);
	
	for (var i = 0; i < array_length(sockets); i++) {
		if (array_contains(except, sockets[i])) continue;
		network_send_packet(sockets[i], packet, len);
	}

	buffer_delete(packet);
}

/// @desc Frees the memory used by a packet.
/// @desc Wrapper over 'buffer_delete'.
/// @arg {Id.Buffer} packet
function packet_destroy(packet)
{
	buffer_delete(packet);
}

/// @desc Frees the memory used by a packet.
/// @desc Wrapper over 'buffer_delete'.
/// @arg {Id.Buffer} packet
function packet_delete(packet)
{
	buffer_delete(packet);
}

