players = [];

players_map = ds_map_create();

players_spell_info = ds_map_create();

spell_platforms = [];

spell_cooldowns = [];

cast_spells = ds_map_create();

chests = [];

potions = ds_map_create();

total_potions = 0;

state = GameState.LOBBY;

void_y = 100000;

Player = function(id_) constructor {
	id = id_;
	name = "";
	hp = 100;
	x = 664;
	y = 588;
	potion = Potion.NONE;
	
	devil_pact_active = false;
	devil_pact_time = 0.0;
	devil_pact_hp_taken = 0.0;
	devil_pact_completed = false;
	devil_pact_used = false;
}

/// @desc Fully syncs a newly joined player
/// @arg {Real} new_player_id
sync_new_player = function(new_player_id) {
	for (var i = 0; i < array_length(players); i++) {
		packet_send(oClientHandler.client, packet_create(new_player_id, PacketType.HOST_SYNC_PLAYER, players[i]));
	}
	
	for (var i = 0; i < array_length(spell_platforms); i++) {
		packet_send(oClientHandler.client, packet_create(new_player_id, PacketType.HOST_SYNC_SPELL_PLATFORM,
			spell_platforms[i]
		));
	}
}

server_info_host_callback = function(data) {
	var player = new Player(data.client_id);
	array_push(players, player);
	players_map[? data.client_id] = player;
	players[0].name = global.player_name;
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER, players[0]));
	players_spell_info[? data.client_id] = {
		total_spells: 0,
		spells: [new SpellSlot(), new SpellSlot()]
	};
}

server_info_connection_request_callback = function(data) {
	var player = new Player(data.client_id);
	array_push(players, player);
	players_map[? data.client_id] = player;
	packet_send(oClientHandler.client, packet_create(data.client_id, PacketType.HOST_INFO_CONNECTION_ACCEPTED, {client_id: data.client_id}))
	sync_new_player(data.client_id);
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER, player));
	players_spell_info[? data.client_id] = {
		total_spells: 0,
		spells: [new SpellSlot(), new SpellSlot()]
	};
}

server_info_client_disconnected = function(data) {
	// now we know that a player disconnected.
	switch (state) {
		case GameState.LOBBY:
		case GameState.POSTGAME:
		case GameState.PREGAME_LOADING:
			packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_INFO_CLIENT_DISCONNECTED,
			{client_id: data.client_id}));
			break;
		default:
			packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_DIED,
			{player_id: data.client_id}));
			packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_INFO_CLIENT_DISCONNECTED,
			{client_id: data.client_id}));
			break;
	}
	// let's remove the player now:
	var idx = -1;
	for (var i = 0; i < array_length(players); i++) {
		if (players[i].id == data.client_id) {
			idx = i;
			break;
		}
	}
	if (idx != -1) {
		array_delete(players, idx, 1);
	}
	ds_map_delete(players_map, data.client_id);
	ds_map_delete(players_spell_info, data.client_id);

}

client_info_player_name_callback = function(data) {
	players_map[? data.sender_id].name = data.name;
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_NAME, {player_id: data.sender_id, name: data.name}));
}

client_info_player_position_callback = function(data) {
	players_map[? data.sender_id].x = data.x;
	players_map[? data.sender_id].y = data.y;
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_POSITION, {player_id: data.sender_id, x: data.x, y: data.y, accepted: true}));
	if (data.y > void_y) {
		damage_player(data.sender_id, 100);
	} 
}

client_info_player_state_callback = function(data) {
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_STATE, {player_id: data.sender_id, state: data.state, direction: data.direction}))
}

client_request_spellcast_callback = function(data) {
	if (!ds_map_exists(players_map, data.sender_id)) {
		return;
	}
	var player_info = players_spell_info[? data.sender_id];
	
	if (data.slot_index < 0 || data.slot_index >= array_length(player_info.spells)) {
		return;
	}
	
	if (player_info.spells[data.slot_index].type == Spell.NONE) {
		return;
	}
	
	if (player_info.spells[data.slot_index].cooldown > 0) {
		return;
	}
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELLCAST,
		{
			caster_id: data.sender_id, 
			spell_id: player_info.total_spells, 
			spell_type: player_info.spells[data.slot_index].type,
			x: players_map[? data.sender_id].x,
			y: players_map[? data.sender_id].y - sprite_get_height(sPlayerIdleRed) / 2,
			direction: data.direction
		}));
	
	ds_map_add(cast_spells, $"{data.sender_id} {player_info.total_spells}", player_info.spells[data.slot_index].type);
	
	player_info.total_spells++;
	player_info.spells[data.slot_index].casts_remaining--;
	player_info.spells[data.slot_index].cooldown = global.spellcast_cooldown;
	
	array_push(spell_cooldowns, {caster_id: data.sender_id, slot_index: data.slot_index});
	
	if (player_info.spells[data.slot_index].casts_remaining <= 0) {
		player_info.spells[data.slot_index].casts_remaining = 0;
		player_info.spells[data.slot_index].type = Spell.NONE;
	}
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_SLOT,
		{
			player_id: data.sender_id,
			slot_index: data.slot_index,
			spell: player_info.spells[data.slot_index].type,
			casts: player_info.spells[data.slot_index].casts_remaining,
			cooldown: global.spellcast_cooldown
		}
		));
}

client_request_spellhit_callback = function(data) {
	var map_key = $"{data.sender_id} {data.spell_id}";
	if (!ds_map_exists(cast_spells, map_key)) {
		return;
	}
	
	if (!ds_map_exists(players_map, data.target)) {
		return;
	}
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELLHIT,
		{
			caster_id: data.sender_id, 
			spell_id: data.spell_id, 
			target: data.target, 
			should_destroy: data.should_destroy
		}
	));
	
	damage_player(data.target, spell_get_damage(cast_spells[? map_key]));

	if (data.should_destroy) {
		ds_map_delete(cast_spells, map_key);
	}
}

client_request_spell_get_callback = function(data) {
	if (!ds_map_exists(players_map, data.sender_id)) return;
	if (data.id < 0 || data.id  >= array_length(spell_platforms)) return;
	
	if (spell_platforms[data.id].spell == Spell.NONE) {
		return;
	}

	var idx = -1;
	var info = players_spell_info[? data.sender_id];
	
	for (var i = 0; i < array_length(info.spells); i++) {
		if (players_spell_info[? data.sender_id].spells[i].type == Spell.NONE) {
			idx = i;
			break;
		}
	}
	
	if (idx == -1) {
		return;
	}
	
	var spell = spell_platforms[data.id].spell;
		
	players_spell_info[? data.sender_id].spells[idx].type = spell;
	players_spell_info[? data.sender_id].spells[idx].casts_remaining = spell_get_max_casts(spell);
	
	spell_platforms[data.id].spell = Spell.NONE;
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_PLATFORM,
		spell_platforms[data.id]));
	
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_SLOT,
		{
			player_id: data.sender_id, 
			slot_index: idx, 
			spell: players_spell_info[? data.sender_id].spells[idx].type,
			casts: players_spell_info[? data.sender_id].spells[idx].casts_remaining,
			cooldown: -1
		}));
}

client_request_consume_potion_callback = function(data) {
	if (!ds_map_exists(players_map, data.sender_id)) return;
		
	if (players_map[? data.sender_id].potion == Potion.NONE) return;
	
	var p = players_map[? data.sender_id];
	var pot_type = p.potion;
	
	if (pot_type == Potion.DEVIL) {
		if (p.hp < 50 || p.devil_pact_used) {
			return;
		}
	}
		
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_CONSUME_POTION,
		{
			player_id: data.sender_id,
			potion_type: pot_type	
		}
	));
	
	if (pot_type == Potion.FLAME) {
		var idx = -1;
		var info = players_spell_info[? data.sender_id];
		
		for (var i = 0; i < array_length(info.spells); i++) {
			if (info.spells[i].type == Spell.NONE) {
				idx = i;
				break;
			}
		}
		
		if (idx == -1) {
			return;
		}
		
		info.spells[idx].type = Spell.FIREBALL;
		info.spells[idx].casts_remaining = spell_get_max_casts(Spell.FIREBALL);
		
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_SLOT,
		{
			player_id: data.sender_id, 
			slot_index: idx, 
			spell: players_spell_info[? data.sender_id].spells[idx].type,
			casts: players_spell_info[? data.sender_id].spells[idx].casts_remaining,
			cooldown: -1
		}));
	}
	
	if (pot_type == Potion.LIMITS) {
		var new_size = irandom_range(1, 5);
		resize_spell_slots(players_spell_info[? data.sender_id].spells, new_size);
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_SLOT_NUMBER,
			{
				player_id: data.sender_id,
				new_size: new_size 
			}
		))
	}
	
	if (pot_type == Potion.DECOY) {
		var decoy_dir = choose(-1, 1);
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_DECOY_SPAWN,
			{
				player_id: data.sender_id,
				x: players_map[? data.sender_id].x,
				y: players_map[? data.sender_id].y,
				direction: decoy_dir
			}
		));
	}
	
	if (pot_type == Potion.DEVIL) {
		p.devil_pact_hp_taken = p.hp - 10;
		p.hp = 10;
		p.devil_pact_active = true;
		p.devil_pact_time = 30.0;
		p.devil_pact_used = true;
		damage_player(data.sender_id, 0); // Trigger host broadcast to sync HP to 10
	}
	
	p.potion = Potion.NONE;
}

client_request_chest_open_callback = function(data) {
	if (data.id < 0 || data.id  >= array_length(chests)) return;
		
	if (chests[data.id].potion == Potion.NONE) return;
		
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_CHEST_OPEN,
		{
			id: data.id,
			potion_type: chests[data.id].potion,
			potion_id: total_potions
		}
	));
	
	ds_map_add(potions, total_potions, chests[data.id].potion);
	total_potions++;
	
	chests[data.id].potion = Potion.NONE;
}

client_request_potion_get_callback = function(data) {
	if (!ds_map_exists(players_map, data.sender_id)) return;
	if (!ds_map_exists(potions, data.id)) return;

	var new_potion = potions[? data.id];
	var old_potion = players_map[? data.sender_id].potion;
	
	if (old_potion != Potion.NONE) {
		// Swap: update the ground potion to the player's old potion
		potions[? data.id] = old_potion;
		players_map[? data.sender_id].potion = new_potion;
		
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_POTION,
			{
				player_id: data.sender_id,
				potion_type: new_potion,
				potion_to_destroy: -1
			}
		));
		
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_POTION_UPDATE,
			{
				potion_id: data.id,
				potion_type: old_potion
			}
		));
	} else {
		// Normal pickup: no potion held
		players_map[? data.sender_id].potion = new_potion;
		
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_POTION,
			{
				player_id: data.sender_id,
				potion_type: new_potion,
				potion_to_destroy: data.id	
			}
		));
	}
}

client_request_throw_potion_callback = function(data) {
	if (!ds_map_exists(players_map, data.sender_id)) return;
		
	var p = players_map[? data.sender_id].potion;
	if (!array_contains(global.throwable_potions, p)) return;
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_THROW_POTION,
		{
			thrower_id: data.sender_id,
			x: players_map[? data.sender_id].x,
			y: players_map[? data.sender_id].y,
			target_x: data.target_x,
			target_y: data.target_y,
			potion_type: p
		}
	));
	
	players_map[? data.sender_id].potion = Potion.NONE;
}

client_request_potion_cloud_hit_callback = function(data) {
	if (!ds_map_exists(players_map, data.target_id)) return;
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_POTION_CLOUD_HIT,
		{
			target_id: data.target_id,
			potion_type: data.potion_type
		}
	));
	
	var pot_type = data.potion_type;
	
	if (pot_type == Potion.LIMITS) {
		var new_size = irandom_range(1, 5);
		resize_spell_slots(players_spell_info[? data.target_id].spells, new_size);
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_SLOT_NUMBER,
			{
				player_id: data.target_id,
				new_size: new_size 
			}
		))
	}
	
	if (pot_type == Potion.DECOY) {
		var decoy_dir = choose(-1, 1);
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_DECOY_SPAWN,
			{
				player_id: data.target_id,
				x: players_map[? data.target_id].x,
				y: players_map[? data.target_id].y,
				direction: decoy_dir
			}
		));
	}
	
	var p = players_map[? data.target_id];
	if (pot_type == Potion.DEVIL) {
		p.devil_pact_hp_taken = p.hp - 10;
		p.hp = 10;
		p.devil_pact_active = true;
		p.devil_pact_time = 30.0;
		p.devil_pact_used = true;
		damage_player(data.target_id, 0); // Trigger host broadcast to sync HP to 10
	}
	
}

client_request_potion_fire_hit_callback = function(data) {
	if (!ds_map_exists(players_map, data.sender_id)) return;
	
	// Fire deals instant death
	damage_player(data.sender_id, 9999);
}

client_request_hit_trap_callback = function(data) {
	if (!ds_map_exists(players_map, data.sender_id)) return;
		
	damage_player(data.sender_id, 9999);
}

with (oClientHandler) {
	subscribe(other, PacketType.SV_INFO_CONNECTION_REQUEST, other.server_info_connection_request_callback);
	subscribe(other, PacketType.SV_INFO_HOST, other.server_info_host_callback);
	subscribe(other, PacketType.CL_INFO_PLAYER_NAME, other.client_info_player_name_callback);
	subscribe(other, PacketType.CL_INFO_PLAYER_POSITION, other.client_info_player_position_callback);
	subscribe(other, PacketType.CL_INFO_PLAYER_STATE, other.client_info_player_state_callback);
	subscribe(other, PacketType.CL_REQ_SPELLCAST, other.client_request_spellcast_callback);
	subscribe(other, PacketType.CL_REQ_SPELLHIT, other.client_request_spellhit_callback);
	subscribe(other, PacketType.CL_REQ_SPELL_GET, other.client_request_spell_get_callback);
	subscribe(other, PacketType.CL_REQ_CONSUME_POTION, other.client_request_consume_potion_callback);
	subscribe(other, PacketType.CL_REQ_CHEST_OPEN, other.client_request_chest_open_callback);
	subscribe(other, PacketType.CL_REQ_POTION_GET, other.client_request_potion_get_callback);
	subscribe(other, PacketType.CL_REQ_THROW_POTION, other.client_request_throw_potion_callback);
	subscribe(other, PacketType.CL_REQ_POTION_CLOUD_HIT, other.client_request_potion_cloud_hit_callback);
	subscribe(other, PacketType.CL_REQ_POTION_FIRE_HIT, other.client_request_potion_fire_hit_callback);
	subscribe(other, PacketType.CL_REQ_HIT_TRAP, other.client_request_hit_trap_callback);
}

/// @desc Damages a player.
/// @arg {Real} player_id
/// @arg {Real} damage
damage_player = function(player_id, damage) {
	var player = players_map[? player_id];
	player.hp -= damage;
	if (player.hp < 0) {
		player.hp = 0;
	}
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_HP,
		{
			player_id: player_id,
			hp: player.hp
		}
	));
	
	if (player.hp <= 0) {
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_DIED,
			{
				player_id: player_id
			}
		));
	}
}

 init_spell_platforms = function() {
	var sp_number = 0;
	with (oSpellPlatform) {
		array_push(other.spell_platforms, {
			id: sp_number,
			spell: irandom_range(1, Spell.LAST - 1),
			x: x,
			y: y
		});
		sp_number++;
        
	}
    
    //spell_platforms[0].spell = Spell.SHIELD;
	
	for (var i = 0; i < sp_number; i++) {
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_PLATFORM,
			spell_platforms[i]
			));
	}
}

 init_chests = function() {
	var chest_number = 0;
	with (oChest) {
		var pot = irandom_range(1, Potion.LAST - 1);
		if (pot == Potion.DEVIL && random(1) > 0.3) {
			pot = irandom_range(1, Potion.DEVIL - 1); // Reroll to other potions
		}
		array_push(other.chests, {
			id: chest_number,
			potion: pot,
			x: x,
			y: y,
		});
		chest_number++;
	}
	
	for (var i = 0; i < chest_number; i++) {
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_CHEST,
			chests[i]
			));
	}
}

total_rooms = 0;

var _toateCamerele = [
    rmLootSmall0, rmLootSmall1, rmLootSmall2, rmLootSmall3, rmLootSmall4, rmLootSmall5, rmLootSmall6,
    rmLootSmall7, rmLootSmall8, rmLootSmall9, rmLootSmall10, rmLootSmall11, rmLootSmall12,
    
    rmLootMedium0, rmLootMedium1, rmLootMedium2, rmLootMedium3, rmLootMedium4, rmLootMedium5,
    rmLootMedium6, rmLootMedium7, rmLootMedium8, rmLootMedium9, rmLootMedium10, rmLootMedium11,
    
    rmCorridorSmall0, rmCorridorSmall1, rmCorridorSmall2, rmCorridorSmall3, rmCorridorSmall4, rmCorridorSmall5,
    rmCorridorSmall6, rmCorridorSmall7, rmCorridorSmall8, rmCorridorSmall9, rmCorridorSmall10, rmCorridorSmall11,
    rmCorridorSmall12, rmCorridorSmall13, rmCorridorSmall14, rmCorridorSmall15, rmCorridorSmall16, rmCorridorSmall17,
    rmCorridorSmall18, rmCorridorSmall19, rmCorridorSmall20, rmCorridorSmall21, rmCorridorSmall22,
    rmCorridorSmall23, rmCorridorSmall24, 
    
    rmCorridorMedium0, rmCorridorMedium1, rmCorridorMedium2, rmCorridorMedium3, rmCorridorMedium4, rmCorridorMedium5,
    rmCorridorMedium6, rmCorridorMedium7, rmCorridorMedium8, rmCorridorMedium9, rmCorridorMedium10, rmCorridorMedium11,
    rmCorridorMedium12, rmCorridorMedium13,  rmCorridorMedium14,
    
    rmArenaMedium0, rmArenaMedium1, rmArenaMedium2, rmArenaMedium3, rmArenaMedium4,
    rmArenaMedium5, rmArenaMedium6, rmArenaMedium7,
    
    rmArenaLarge0, rmArenaLarge1,
    
    rmWallHorizontalSimple, rmWallVerticalSimple, rmWallHorizontalDouble, rmWallVerticalDouble,
    
    rmFallMedium0, rmFallMedium1, rmFallMedium2, 
    rmFallSmall0, rmFallSmall1, rmFallSmall2
];

if (!variable_global_exists("intrariHarta")) {
    global.intrariHarta = PrecalculateRoomData(_toateCamerele);
}

ts_restock_consumables = time_source_create(time_source_game, 5 * 60, time_source_units_seconds, function(){init_chests();init_spell_platforms();}, [], -1);

generate_map = function() {
    packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_INFO_MAP_LOADING));
    
    var map_size = 15 + 2 * array_length(players);
    
    var dungeon_rooms = GenerateBestRadialMap(map_size, global.intrariHarta);
    
    total_rooms = array_length(dungeon_rooms);
    
	var maxy = -100;
    for (var i = 0; i < total_rooms; i++) {
        packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_INFO_DUNGEON_ROOM,
            {
                room_index: dungeon_rooms[i].room_index, 
                world_x: dungeon_rooms[i].world_x,
                world_y: dungeon_rooms[i].world_y
            }
        ));
		if (dungeon_rooms[i].world_y + dungeon_rooms[i].height > maxy) {
			maxy = dungeon_rooms[i].world_y + dungeon_rooms[i].height;
		}
    }
	
	void_y = maxy + 1000;
	time_source_start(ts_restock_consumables);
}
//init_spell_platforms();
