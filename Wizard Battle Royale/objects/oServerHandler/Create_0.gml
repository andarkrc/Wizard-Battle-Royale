port = 6000;
max_clients = 10;

server = network_create_server(network_socket_tcp, port, max_clients);

while (server < 0 && port < 65535) {
	port++;
	server = network_create_server(network_socket_tcp, port, max_clients);
}

if (server < 0) {
	oUIHandler.add_popup("Unknown Error", "For some reason, the internal server could not start.");
	room_goto(rmMainMenu);
} else {
	oUIHandler.add_popup($"Server PORT: {port}", "Have Fun! (:", PopupType.INFO);
}

clients = [];