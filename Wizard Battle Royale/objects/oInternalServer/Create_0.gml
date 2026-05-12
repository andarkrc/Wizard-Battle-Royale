players = [];

players_map = ds_map_create();

players_spell_info = ds_map_create();

spell_platforms = [];

spell_cooldowns = [];

cast_spells = ds_map_create();

chests = [];

potions = ds_map_create();

total_potions = 0;

Player = function(id_) constructor {
	id = id_;
	name = "";
	hp = 100;
	x = 664;
	y = 588;
	potion = Potion.SPEED;
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
		max_spells: 2,
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
		max_spells: 2,
		spells: [new SpellSlot(), new SpellSlot()]
	};
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
			y: players_map[? data.sender_id].y - sprite_get_height(sPlayerIdle) / 2,
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
	
	packet_send(oClientHandler.client, packet_create(data.sender_id, PacketType.HOST_SYNC_SPELL_SLOT,
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
	
	for (var i = 0; i < players_spell_info[? data.sender_id].max_spells; i++) {
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
	
	//spell_platforms[data.id].spell = Spell.NONE;
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_PLATFORM,
		spell_platforms[data.id]));
	
	
	packet_send(oClientHandler.client, packet_create(data.sender_id, PacketType.HOST_SYNC_SPELL_SLOT,
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
		
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_CONSUME_POTION,
		{
			player_id: data.sender_id,
			potion_type: players_map[? data.sender_id].potion	
		}
	));
	
	players_map[? data.sender_id].potion = Potion.NONE;
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
		
	if (players_map[? data.sender_id].potion != Potion.NONE) return;

	var new_potion = potions[? data.id];
	players_map[? data.sender_id].potion = new_potion;
	
	packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_POTION,
		{
			player_id: data.sender_id,
			potion_type: new_potion,
			potion_to_destroy: data.id	
		}
	));
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
		other.spell_platforms[sp_number].spell = Spell.WIND_SLASH;
		sp_number++;
	}
	
	for (var i = 0; i < sp_number; i++) {
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_PLATFORM,
			spell_platforms[i]
			));
	}
}

 init_chests = function() {
	var chest_number = 0;
	with (oChest) {
		array_push(other.chests, {
			id: chest_number,
			potion: irandom_range(1, Potion.LAST - 1),
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

generate_map = function() {
	init_spell_platforms();
	init_chests();
}

generate_map();