if (async_load[? "id"] == client && async_load[? "type"] == network_type_data) {
	var packet = async_load[? "buffer"];
	
	buffer_seek(packet, buffer_seek_start, 0);
	var version = buffer_read(packet, STRING);
	
	var data = packet_parse_server_packet(packet);
	switch (data.type) {
		case PacketType.SV_INFO_LOBBY_LIST:
			array_push(lobbies, {text: data.name, text_right: $"{data.players}/{data.max_players}", 
			data: {code: data.code, players: data.players, max_players: data.max_players}});
			break;
		
		default:
			break;
	}
}