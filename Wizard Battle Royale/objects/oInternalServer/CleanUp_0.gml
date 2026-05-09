ds_map_destroy(players_map);
ds_map_destroy(players_spell_info);

with (oClientHandler) {
	unsubscribe_all(other);
}