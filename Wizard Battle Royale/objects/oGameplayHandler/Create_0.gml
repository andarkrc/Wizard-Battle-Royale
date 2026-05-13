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
	player.hp = data.hp;
	player.potion = data.potion;
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

host_sync_consume_potion_callback = function(data) {
	if (!check_host(data)) return;
		
	with (oPlayer) {
		if (id_ == data.player_id) {
			potion = data.potion_type;
			drink_potion();
		}
	}
}

host_sync_chest_callback = function(data) {
	if (!check_host(data)) return;
		
	with (oChest) {
		if (id_ == data.id || (x == data.x && y == data.y)) {
			id_ = data.id;
			potion = data.potion;
		}
	}
}

host_sync_player_potion_callback = function(data) {
	if (!check_host(data)) return;
		
	with (oPlayer) {
		if (id_ == data.player_id) {
			potion = data.potion_type;
		}
	}
	
	if (data.potion_to_destroy != -1) {
		with (oPotion) {
			if (id_ == data.potion_to_destroy) {
				instance_destroy();
			}
		}
	}
}

host_sync_chest_open_callback = function(data) {
	if (!check_host(data)) return;
	
	with (oChest) {
		if (data.id == id_) {
			potion = Potion.NONE;
			with (instance_create_layer(x + sprite_width / 2, y, "Instances", oPotion)) {
				id_ = data.potion_id;
				potion = data.potion_type;	
			}
		}
	}
}

host_sync_spell_slot_number_callback = function(data) {
	if (!check_host(data)) return;
	
	with (oPlayer) {
		if (id_ == data.player_id) {
			resize_spell_slots(spells, data.new_size);
			if (selected_spell >= array_length(spells)) {
				selected_spell = 0;
			}
		}
	}
}

host_info_map_loading_callback = function(data) {
	if (!check_host(data)) return;
	
	layer_set_visible("Foreground", true);
	layer_set_visible("Foreground_Text", true);
	
	state = GameState.PREGAME_LOADING;
	
	lobby.Cleanup(false);
	init_all_rooms();
	
	
}

host_info_dungeon_room_callback = function(data) {
	if (!check_host(data)) return;
	array_push(rooms, RoomLoader.Load(asset_get_index(data.room_index), data.world_x, data.world_y));
	show_debug_message($"Received a new room {array_length(rooms)}");
}

host_info_game_start_callback = function(data) {
	if (!check_host(data)) return;
		
	layer_set_visible("Foreground", false);
	layer_set_visible("Foreground_Text", false);
	
	state = GameState.GAME;
	
	with (oUIHandler) {
		should_stretch_view = false;
	}
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
	subscribe(other, PacketType.HOST_SYNC_CONSUME_POTION, other.host_sync_consume_potion_callback);
	subscribe(other, PacketType.HOST_SYNC_CHEST, other.host_sync_chest_callback);
	subscribe(other, PacketType.HOST_SYNC_PLAYER_POTION, other.host_sync_player_potion_callback);
	subscribe(other, PacketType.HOST_SYNC_CHEST_OPEN, other.host_sync_chest_open_callback);
	subscribe(other, PacketType.HOST_SYNC_SPELL_SLOT_NUMBER, other.host_sync_spell_slot_number_callback);
	subscribe(other, PacketType.HOST_INFO_MAP_LOADING, other.host_info_map_loading_callback);
	subscribe(other, PacketType.HOST_INFO_DUNGEON_ROOM, other.host_info_dungeon_room_callback);
	subscribe(other, PacketType.HOST_INFO_GAME_START, other.host_info_game_start_callback);
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
	switch (data.spell_type) {
		case Spell.FIREBALL:
			with (instance_create_layer(data.x, data.y, "Instances", oFireball)) {
				horizontal_speed = dcos(data.direction) * move_speed;
				vertical_speed = -dsin(data.direction) * move_speed;
				caster_id = data.caster_id;
				spell_id = data.spell_id;
			}
			break;
		
		case Spell.WIND_SLASH:
			with (instance_create_layer(data.x, data.y, "Instances", oWindSlash)) {
				horizontal_speed = dcos(data.direction) * move_speed;
				vertical_speed = -dsin(data.direction) * move_speed;
				caster_id = data.caster_id;
				spell_id = data.spell_id;
				image_angle = data.direction;
			}
			break;
	
		default:
			break;
	}
}

state = GameState.LOBBY;

map = [];

rooms = [];

lobby = undefined;

unload_all_rooms = function() {
	for (var i = 0; i < array_length(rooms); i++) {
		rooms[i].Cleanup(false);
	}
}

init_all_rooms = function() {
	RoomLoader.DataInit(rmArenaLarge0);
	RoomLoader.DataInit(rmArenaMedium0);
	RoomLoader.DataInit(rmArenaMedium1);
	RoomLoader.DataInit(rmArenaMedium2);
	RoomLoader.DataInit(rmArenaMedium3);
	RoomLoader.DataInit(rmCorridorMedium0);
	RoomLoader.DataInit(rmCorridorMedium1);
	RoomLoader.DataInit(rmCorridorMedium2);
	RoomLoader.DataInit(rmCorridorMedium3);
	RoomLoader.DataInit(rmCorridorMedium4);
	RoomLoader.DataInit(rmCorridorSmall0);
	RoomLoader.DataInit(rmCorridorSmall1);
	RoomLoader.DataInit(rmCorridorSmall2);
	RoomLoader.DataInit(rmCorridorSmall3);
	RoomLoader.DataInit(rmCorridorSmall4);
	RoomLoader.DataInit(rmCorridorSmall5);
	RoomLoader.DataInit(rmCorridorSmall6);
	RoomLoader.DataInit(rmCorridorSmall7);
	RoomLoader.DataInit(rmCorridorSmall8);
	RoomLoader.DataInit(rmLootMedium0);
	RoomLoader.DataInit(rmLootMedium1);
	RoomLoader.DataInit(rmLootMedium2);
	RoomLoader.DataInit(rmLootMedium3);
	RoomLoader.DataInit(rmLootSmall0);
	RoomLoader.DataInit(rmLootSmall1);
	RoomLoader.DataInit(rmLootSmall2);
	RoomLoader.DataInit(rmLootSmall3);
	RoomLoader.DataInit(rmLootSmall4);
	RoomLoader.DataInit(rmLootSmall5);
	RoomLoader.DataInit(rmLootSmall6);
}

load_lobby = function() {
	RoomLoader.DataInit(rmTest);
	lobby = RoomLoader.Load(rmTest, 0, 0);
}

load_lobby();

with (oUIHandler) {
	should_stretch_view = true;
}