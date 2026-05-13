var _dt = delta_time / 1000000;
for (var i = 0; i < array_length(spell_cooldowns); i++) {
	var info = spell_cooldowns[i];
	if (!ds_map_exists(players_map, info.caster_id)) {
		array_delete(spell_cooldowns, i, 1);
		i--;
		continue;
	}
	
	if (info.slot_index >= array_length(players_spell_info[? info.caster_id].spells)) {
		array_delete(spell_cooldowns, i, 1);
		i--;
		continue;
	}
	
	var spell_info = players_spell_info[? info.caster_id].spells[info.slot_index];
	
	spell_info.cooldown -= _dt;
	
	if (spell_info.cooldown <= 0) {
		spell_info.cooldown = 0;
		array_delete(spell_cooldowns, i, 1);
		i--;
		continue;
	}
}

if (keyboard_check_pressed(vk_enter) && state == GameState.LOBBY) {
	state = GameState.PREGAME_LOADING;
	show_debug_message("STARTED MAP GENERATION");
	generate_map();
}

if (state == GameState.PREGAME_LOADING) {
	if (total_rooms == array_length(oGameplayHandler.rooms)) {
		// init loot
		show_debug_message("STARTED INITIALIZATION");
		init_spell_platforms();
		init_chests();
		
		for (var i = 0; i < array_length(players); i++) {
			var player = players[i];
			var ok = false;
			show_debug_message($"Trying to spawn player {i}");
			with (oPlayerSpawnPosition) {
				if (random(1) < 0.1 && !ok) {
					player.x = oPlayerSpawnPosition.x;
					player.y = oPlayerSpawnPosition.y;
					packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_PLAYER_POSITION,
						{
							player_id: player.id,
							x: player.x,
							y: player.y,
							accepted: false
						}
					));
					ok = true;
					instance_destroy();
				}
			}
			if (!ok) {
				i--;
			}
		}
		
		instance_destroy(oPlayerSpawnPosition); 
		
		packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_INFO_GAME_START));
		state = GameState.GAME;
	}
}