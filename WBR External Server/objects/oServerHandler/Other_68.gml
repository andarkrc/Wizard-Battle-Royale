if (async_load[? "id"] == server)
{
	var sock = async_load[? "socket"];
	var type = async_load[? "type"];
	if (type == network_type_connect) {
		array_push(clients, sock);
		if (array_length(clients) == 1) {
			packet_send(sock, packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_HOST, {client_id: sock}));
		} else {
			packet_send(clients[0], packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_CONNECTION_REQUEST, {client_id: sock}));
		}
	} else if (type == network_type_disconnect) {
		var idx = -1;
		for (var i = 0; i < array_length(clients); i++) {
			if (clients[i] == sock) {
				idx = i;
				break;
			}
		}
		network_destroy(clients[idx]);
		array_delete(clients, idx, 1);
		if (idx == 0) { // Basically host just disconnected.
			packet_send_multiple(clients, packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_HOST_DISCONNECTED));
		} else {
			packet_send(clients[0], packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_CLIENT_DISCONNECTED, {client_id: sock}));
		}
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
			switch (type) {
				case PacketType.CL_PING:
					packet_send(sock, packet_create_server(NWTarget.SERVER, true, PacketType.SV_PONG));
					break;
				
				default:
					show_debug_message($"[SERVER] Received unknown packet of type '{type}'");
					break;
			}
			break;
		
		case NWTarget.HOST:
			var lobby = client_id_to_lobby[? sock];
			var is_host = (sock == lobby.host);
			packet_send(lobby.host, packet_change_client_to_server(packet, sock, is_host));
			break;
		
		case NWTarget.OTHER:
			var lobby = client_id_to_lobby[? sock];
			var is_host = (sock == lobby.host);
			packet_send_multiple_except(lobby.players, packet_change_client_to_server(packet, sock, is_host), sock);
			break;
		
		case NWTarget.ALL:
			var lobby = client_id_to_lobby[? sock];
			var is_host = (sock == lobby.host); 
			packet_send_multiple(lobby.players, packet_change_client_to_server(packet, sock, is_host));
			break;
		
		default:
			// If packet is malformed, it's gonna crash xd
			var lobby = client_id_to_lobby[? sock];
			if (!array_contains(lobby.players, target)) break; // no security risks here xd
			var is_host = (sock == lobby.host);
			packet_send(target, packet_change_client_to_server(packet, sock, is_host));
			break;
	}
}