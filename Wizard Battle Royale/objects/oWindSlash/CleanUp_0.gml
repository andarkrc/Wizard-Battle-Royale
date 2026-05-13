ds_map_destroy(players_hit);

with (oInternalServer) {
	var map_key = $"{other.caster_id} {other.spell_id}";
	if (ds_map_exists(cast_spells, map_key)) {
		ds_map_delete(cast_spells, map_key);
	}
}