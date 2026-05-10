var _dt = delta_time / 1000000;
for (var i = 0; i < array_length(spell_cooldowns); i++) {
	var info = spell_cooldowns[i];
	if (!ds_map_exists(players_map, info.caster_id)) {
		array_delete(spell_cooldowns, i, 1);
		i--;
		continue;
	}
	
	if (info.slot_index >= players_spell_info[? info.caster_id].max_spells) {
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