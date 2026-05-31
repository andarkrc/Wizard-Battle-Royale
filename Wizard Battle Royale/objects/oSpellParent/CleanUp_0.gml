with (oInternalServer) {
	var map_key = $"{other.caster_id} {other.spell_id}";
	if (ds_exists(cast_spells, ds_type_map) && ds_map_exists(cast_spells, map_key)) {
		ds_map_delete(cast_spells, map_key);
	}
}

spellhit_sound = audio_play_sound_at(sndSpellhit, x, y, 0, global.fallof_ref, global.fallof_max, 1, false, 1);