player_refs = ds_map_create();

particle_system = part_system_create_layer("Instances", false);


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
	if (!ds_map_exists(player_refs, data.player_id)) return;
	player_refs[? data.player_id].x = data.x;
	player_refs[? data.player_id].y = data.y;
}

host_sync_player_state_callback = function(data) {
	if (!check_host(data)) return;
	if (data.player_id == oClientHandler.client_id) return;
	if (!ds_map_exists(player_refs, data.player_id)) return;
	player_refs[? data.player_id].state = data.state;
	player_refs[? data.player_id].image_xscale = data.direction;
}

host_sync_spellcast_callback = function(data) {
	if (!check_host(data)) return;
	with (instance_create_layer(data.x, data.y, "Instances", oFireball)) {
		horizontal_speed = dcos(data.direction) * move_speed;
		vertical_speed = -dsin(data.direction) * move_speed;
		caster_id = data.player_id;
		spell_id = data.spell_id;
	}
}

host_sync_spellhit_callback = function(data) {
	if (!check_host(data)) return;
	with (oFireball) {
		if (caster_id == data.caster_id && spell_id == data.spell_id) {
			instance_destroy();
		}	
	}
	with (oPlayer) {
		if (id_ == data.target) {
			vertical_speed = -2;
			damaged = true;
			time_source_start(ts_reset_damage);
		}
	}
	show_debug_message($"A Player was hit");
}

with (oClientHandler) {
	subscribe(other, PacketType.HOST_SYNC_PLAYER, other.host_sync_player_callback);
	subscribe(other, PacketType.HOST_INFO_CONNECTION_ACCEPTED, other.host_info_connection_accepted_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_NAME, other.host_sync_player_name_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_POSITION, other.host_sync_player_position_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_STATE, other.host_sync_player_state_callback);
	subscribe(other, PacketType.HOST_SYNC_SPELLCAST, other.host_sync_spellcast_callback);
	subscribe(other, PacketType.HOST_SYNC_SPELLHIT, other.host_sync_spellhit_callback);
}