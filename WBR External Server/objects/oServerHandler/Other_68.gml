if (async_load[? "id"] == server)
{
	var sock = async_load[? "socket"];
	var type = async_load[? "type"];
	if (type == network_type_connect) {
		array_push(clients, sock);
	} else if (type == network_type_disconnect) {
		handle_disconnect(sock);
	}
}

// Check if it's a data event && if the sender is from my clients list
if (async_load[? "type"] == network_type_data && 
	array_contains(clients, async_load[? "id"]))
{
	var sock = async_load[? "id"];
	var packet = async_load[? "buffer"];
	buffer_seek(packet, buffer_seek_start, 0);
	var version = buffer_read(packet, STRING);
	var target = buffer_read(packet, S32);
	var type = buffer_read(packet, S32);
	switch (target) {
		case NWTarget.SERVER:
			if (version != global.networking_version) {
				show_debug_message($"[SERVER] Received packet of different version: {version} (my: {global.networking_version})");
				break;
			}
			var data = packet_parse_client_packet(packet);
			switch (type) {
				case PacketType.CL_PING:
					packet_send(sock, packet_create_server(NWTarget.SERVER, true, PacketType.SV_PONG));
					break;
				
				case PacketType.CL_REQ_CREATE_LOBBY:
					handle_create_lobby(sock, data);
					break;
				
				case PacketType.CL_REQ_JOIN_LOBBY:
					handle_join_lobby(sock, data);
					break;
				
				case PacketType.CL_REQ_LOBBY_LIST:
					send_lobby_list(sock, data);
					break;
				
				case PacketType.HOST_REQ_REMOVE_FROM_LOBBY:
					handle_remove_from_lobby(sock, data);
					break;
				
				default:
					show_debug_message($"[SERVER] Received unknown packet of type '{type}'");
					break;
			}
			break;
		
		case NWTarget.HOST:
			if (!ds_map_exists(client_id_to_lobby, sock)) break;
			var lobby = client_id_to_lobby[? sock];
			var is_host = (sock == lobby.host);
			packet_send(lobby.host, packet_change_client_to_server(packet, sock, is_host));
			break;
		
		case NWTarget.OTHER:
			if (!ds_map_exists(client_id_to_lobby, sock)) break;
			var lobby = client_id_to_lobby[? sock];
			var is_host = (sock == lobby.host);
			packet_send_multiple_except(lobby.players, packet_change_client_to_server(packet, sock, is_host), sock);
			break;
		
		case NWTarget.ALL:
			if (!ds_map_exists(client_id_to_lobby, sock)) break;
			var lobby = client_id_to_lobby[? sock];
			var is_host = (sock == lobby.host); 
			packet_send_multiple(lobby.players, packet_change_client_to_server(packet, sock, is_host));
			break;
		
		default:
			// If packet is malformed, it's gonna crash xd
			if (!ds_map_exists(client_id_to_lobby, sock)) break;
			var lobby = client_id_to_lobby[? sock];
			if (!array_contains(lobby.players, target)) break; // no security risks here xd
			var is_host = (sock == lobby.host);
			packet_send(target, packet_change_client_to_server(packet, sock, is_host));
			break;
	}
}