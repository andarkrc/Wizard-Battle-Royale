players = [];

players_map = ds_map_create();

Player = function(id_) constructor {
	id = id_;
	name = "";
	x = 672;
	y = 704;
	total_spells = 0;
}

sync_new_player = function(new_player_id) {
	for (var i = 0; i < array_length(players); i++) {
		packet_send(oClientHandler.client, packet_create(new_player_id, PacketType.HOST_SYNC_PLAYER, players[i]));
	}
}

server_info_host_callback = function(data) {
	var player = new Player(data.client_id);
	array_push(players, player);
	players_map[? data.client_id] = player;
	players[0].name = global.player_name;
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER, players[0]));
}

server_info_connection_request_callback = function(data) {
	var player = new Player(data.client_id);
	array_push(players, player);
	players_map[? data.client_id] = player;
	packet_send(oClientHandler.client, packet_create(data.client_id, PacketType.HOST_INFO_CONNECTION_ACCEPTED, {client_id: data.client_id}))
	sync_new_player(data.client_id);
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER, player));
}

server_info_client_disconnected = function(data) {
	// now we know that a player disconnected.
}

client_info_player_name_callback = function(data) {
	players_map[? data.sender_id].name = data.name;
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_NAME, {player_id: data.sender_id, name: data.name}));
}

client_info_player_position_callback = function(data) {
	players_map[? data.sender_id].x = data.x;
	players_map[? data.sender_id].y = data.y;
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_POSITION, {player_id: data.sender_id, x: data.x, y: data.y, accepted: true}));
}

client_info_player_state_callback = function(data) {
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_STATE, {player_id: data.sender_id, state: data.state, direction: data.direction}))
}

client_request_spellcast_callback = function(data) {
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELLCAST, 
	{player_id: data.sender_id, spell_id: players_map[? data.sender_id].total_spells, x: data.x, y: data.y, direction: data.direction}));
	players_map[? data.sender_id].total_spells++;
}

client_request_spellhit_callback = function(data) {
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELLHIT,
	{caster_id: data.sender_id, spell_id: data.spell_id, target: data.target}));
}

with (oClientHandler) {
	subscribe(other, PacketType.SV_INFO_CONNECTION_REQUEST, other.server_info_connection_request_callback);
	subscribe(other, PacketType.SV_INFO_HOST, other.server_info_host_callback);
	subscribe(other, PacketType.CL_INFO_PLAYER_NAME, other.client_info_player_name_callback);
	subscribe(other, PacketType.CL_INFO_PLAYER_POSITION, other.client_info_player_position_callback);
	subscribe(other, PacketType.CL_INFO_PLAYER_STATE, other.client_info_player_state_callback);
	subscribe(other, PacketType.CL_REQ_SPELLCAST, other.client_request_spellcast_callback);
	subscribe(other, PacketType.CL_REQ_SPELLHIT, other.client_request_spellhit_callback);
}