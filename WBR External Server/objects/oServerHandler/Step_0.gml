for (var i = 0; i < array_length(lobby_list_queue); i++) {
	var j = lobby_list_queue[i].idx;
	if (j < array_length(lobbies)) {
		if (!lobbies[j].public) {
			lobby_list_queue[i].idx++;
			continue;
		}
		packet_send_udp(socket_udp, lobby_list_queue[i].ip, lobby_list_queue[i].port,
		packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_LOBBY_LIST,
		{
			name: lobbies[j].name,
			code: lobbies[j].code,
			players: array_length(lobbies[j].players),
			max_players: lobbies[j].max_player_count
		}));
		lobby_list_queue[i].idx++;
	} else {
		array_delete(lobby_list_queue, i, 1);
		i--;
	}
}