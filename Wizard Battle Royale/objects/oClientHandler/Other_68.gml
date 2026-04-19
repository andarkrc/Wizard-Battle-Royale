if (async_load[? "id"] == client) {
	var packet = async_load[? "buffer"];
	
	buffer_seek(packet, buffer_seek_start, 0);
	var version = buffer_read(packet, STRING);
	
	var data = packet_parse_server_packet(packet);
	if (version == global.networking_version) {
		var type = data.type;
		// General client packets
		show_debug_message($"[CLIENT] Received packet of type {type}");
		switch (type) {
			case PacketType.SV_PONG :
				ping_received = true;
				break;
			
			case PacketType.SV_INFO_HOST :
				is_host = true;
				client_id = data.packet_id;
				instance_create_layer(0, 0, "Instances", oInternalServer);
				break;
			
			default:
				signal(data);
				break;
		}
	} else {
		show_debug_message($"[CLIENT] Wrong version: {version}");
	}
}