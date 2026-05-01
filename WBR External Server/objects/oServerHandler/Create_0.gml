port = 6000;
max_clients = 10;

if (global.connection_type == "direct-client") instance_destroy();

server = network_create_server(network_socket_tcp, port, max_clients);

while (server < 0 && port < 65535) {
	port++;
	server = network_create_server(network_socket_tcp, port, max_clients);
}

if (server < 0) game_end();

show_debug_message($"[SERVER] Started on port {port}");

clients = [];

lobbies = [];

client_id_to_lobby = ds_map_create();
lobby_code_to_lobby = ds_map_create();

Lobby = function(host_id) constructor {
	host = host_id;
	code = "";
	name = "";
	max_player_count = 10;
	public = false;
	players = [host_id];
}

handle_disconnect = function(sock) {
	
}

handle_create_lobby = function(sock, data) {
	
}

handle_join_lobby = function(sock, data) {
	
}