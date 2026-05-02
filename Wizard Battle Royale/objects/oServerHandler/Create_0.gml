port = 6000;
max_clients = 10;

server = network_create_server(network_socket_tcp, port, max_clients);

while (server < 0 && port < 65535) {
	port++;
	server = network_create_server(network_socket_tcp, port, max_clients);
}

if (server < 0) game_end();

show_debug_message($"[SERVER] Started on port {port}");

clients = [];