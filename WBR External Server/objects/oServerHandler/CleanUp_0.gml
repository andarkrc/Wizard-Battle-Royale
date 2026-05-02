for (var i = 0; i < array_length(clients); i++) {
	network_destroy(clients[i]);
}
network_destroy(server);

ds_map_destroy(lobby_code_to_lobby);
ds_map_destroy(client_id_to_lobby);