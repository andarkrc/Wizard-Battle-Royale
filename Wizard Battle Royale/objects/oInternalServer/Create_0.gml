players = [];

players_map = ds_map_create();

Player = function(id_) constructor {
	id = id_;
	name = "";
	x = 0;
	y = 0;
}

info_connection_request_callback = function(data) {
	var player = new Player(data.client_id);
	array_push(players, player);
	players_map[? data.client_id] = player;
	packet_send(oClientHandler.client, packet_create(data.client_id, PacketType.HOST_INFO_CONNECTION_ACCEPTED, {client_id: data.client_id}))
}

with (oClientHandler) {
	subscribe(other, PacketType.SV_INFO_CONNECTION_REQUEST, other.info_connection_request_callback);
}