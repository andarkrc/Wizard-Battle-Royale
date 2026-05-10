player_refs = ds_map_create();

particle_system = part_system_create_layer("Instances", false);

runtime_objects = [];

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

server_info_host_disconnected_callback = function(data) {
	if (!check_host(data)) return;
	show_debug_message("HOST DISCONNECTED. RETURNING TO MAIN MENU.");
	room_goto(rmMainMenu);
}

host_info_connection_rejected_callback = function(data) {
	if (!check_host(data)) return;
	show_debug_message($"CONNECTION REJECTED: {data.message}");
	room_goto(rmMainMenu);
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
	cast_spell(data);
}

host_sync_spellhit_callback = function(data) {
	if (!check_host(data)) return;
	if (data.should_destroy) {
		with (oSpellParent) {
			if (caster_id == data.caster_id && spell_id == data.spell_id) {
				instance_destroy();
			}	
		}
	}
	with (oPlayer) {
		if (id_ == data.target) {
			vertical_speed = -2 * METER;
			damaged = true;
			time_source_start(ts_reset_damage);
		}
	}
	show_debug_message($"A Player was hit");
}

host_sync_spell_platform_callback = function(data) {
	if (!check_host(data)) return;
		
	with (oSpellPlatform) {
		if (id_ == data.id || (x == data.x && y == data.y)) {
			id_ = data.id;
			spell = data.spell;
		}
	}
}

host_sync_spell_slot_callback = function(data) {
	if (!check_host(data)) return;
	
	with (oPlayer) {
		if (id_ == data.player_id) {
			spells[data.slot_index].type = data.spell;
			spells[data.slot_index].casts_remaining = data.casts;
			if (data.cooldown != -1) {
				spells[data.slot_index].cooldown = data.cooldown;
			}
		}
	}
}

host_sync_player_hp_callback = function(data) {
	if (!check_host(data)) return;
		
	with (oPlayer) {
		if (id_ == data.player_id) {
			hp = data.hp;
		}
	}
}

host_sync_player_died_callback = function(data) {
	if (!check_host(data)) return;
}

with (oClientHandler) {
	subscribe(other, PacketType.SV_INFO_HOST_DISCONNECTED, other.server_info_host_disconnected_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER, other.host_sync_player_callback);
	subscribe(other, PacketType.HOST_INFO_CONNECTION_ACCEPTED, other.host_info_connection_accepted_callback);
	subscribe(other, PacketType.HOST_INFO_CONNECTION_REJECTED, other.host_info_connection_rejected_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_NAME, other.host_sync_player_name_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_POSITION, other.host_sync_player_position_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_STATE, other.host_sync_player_state_callback);
	subscribe(other, PacketType.HOST_SYNC_SPELLCAST, other.host_sync_spellcast_callback);
	subscribe(other, PacketType.HOST_SYNC_SPELLHIT, other.host_sync_spellhit_callback);
	subscribe(other, PacketType.HOST_SYNC_SPELL_PLATFORM, other.host_sync_spell_platform_callback);
	subscribe(other, PacketType.HOST_SYNC_SPELL_SLOT, other.host_sync_spell_slot_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_HP, other.host_sync_player_hp_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_DIED, other.host_sync_player_died_callback);
}

clean_runtime_objects = function() {
	for (var i = 0; i < array_length(runtime_objects); i++) {
		if (instance_exists(runtime_objects[i])) {
			instance_destroy(runtime_objects[i]);
		}
	}
	
	runtime_objects = [];
}

/// @desc Creates a new spell depending on casting info.
/// @arg {Struct} data - data containing info about the spell
cast_spell = function(data) {
	var new_spell = noone;
	
	switch (data.spell_type) {
		case Spell.FIREBALL:
			new_spell = instance_create_layer(data.x, data.y, "Instances", oFireball)
			with (new_spell) {
				horizontal_speed = dcos(data.direction) * move_speed;
				vertical_speed = -dsin(data.direction) * move_speed;
				caster_id = data.caster_id;
				spell_id = data.spell_id;
			}
			break;
	
		default:
			break;
	}
	
	if (new_spell != noone) {
		array_push(runtime_objects, new_spell);
	}
}