player_refs = ds_map_create();

create_player_if_doesnt_exist = function(id_) {
	if (!ds_map_exists(player_refs, id_)) {
		var new_player = instance_create_layer(0, 0, "Instances", oPlayer);
		new_player.id_ = id_;
		player_refs[? id_] = new_player;
	}
}

check_host = function (data) {
	return data.sender_is_host;
}

host_sync_player_callback = function(data) {
	if (!check_host(data)) return;
	create_player_if_doesnt_exist(data.id);
	var player = player_refs[? data.id];
	player.name = data.name;
	player.x = data.x;
	player.y = data.y;
}

host_info_connection_accepted_callback = function(data) {
	if (!check_host(data)) return;
	packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_INFO_PLAYER_NAME, {name: global.player_name}));
}

host_sync_player_name_callback = function(data) {
	if (!check_host(data)) return;
	player_refs[? data.player_id].name = data.name;
}

host_sync_player_position_callback = function(data) {
	if (!check_host(data)) return;
	if (data.player_id == oClientHandler.client_id && data.accepted) return;
	player_refs[? data.player_id].x = data.x;
	player_refs[? data.player_id].y = data.y;
}

with (oClientHandler) {
	subscribe(other, PacketType.HOST_SYNC_PLAYER, other.host_sync_player_callback);
	subscribe(other, PacketType.HOST_INFO_CONNECTION_ACCEPTED, other.host_info_connection_accepted_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_NAME, other.host_sync_player_name_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_POSITION, other.host_sync_player_position_callback);
}