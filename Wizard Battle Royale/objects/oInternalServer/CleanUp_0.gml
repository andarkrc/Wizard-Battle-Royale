ds_map_destroy(players_map);
ds_map_destroy(players_spell_info);
ds_map_destroy(cast_spells);
ds_map_destroy(potions);

with (oClientHandler) {
	unsubscribe_all(other);
}