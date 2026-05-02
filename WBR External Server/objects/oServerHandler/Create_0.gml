port = 6100;
max_clients = 1000;

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

lobby_close = function(lobby) {
	for (var i = 0; i < array_length(lobby.players); i++) {
		if (!ds_map_exists(client_id_to_lobby, lobby.players[i])) continue;
		
		ds_map_delete(client_id_to_lobby, lobby.players[i]);
	}
	// delete the lobby
	var idx = -1;
	for (var i = 0; i < array_length(lobbies); i++) {
		if (lobby == lobbies[i]) {
			idx = i;
		}
	}
	if (idx != -1) {
		array_delete(lobbies, idx, 1);
	}
	ds_map_delete(lobby_code_to_lobby, lobby.code);
}

remove_from_lobby = function(sock) {
	if (!ds_map_exists(client_id_to_lobby, sock)) return;
	
	var lobby = client_id_to_lobby[? sock];
	ds_map_delete(client_id_to_lobby, sock);
	var idx = -1;
	for (var i = 0; i < array_length(lobby.players); i++) {
		if (lobby.players[i] == sock) {
			idx = i;
			break;
		}
	}
	if (idx != -1) {
		array_delete(lobby.players, idx, 1);
	}
	if (array_length(lobby.players) == 0) {
		// delete the lobby
		var idx = -1;
		for (var i = 0; i < array_length(lobbies); i++) {
			if (lobby == lobbies[i]) {
				idx = i;
			}
		}
		if (idx != -1) {
			array_delete(lobbies, idx, 1);
		}
		ds_map_delete(lobby_code_to_lobby, lobby.code);
	}
}

handle_disconnect = function(sock) {
	var idx = -1;
	for (var i = 0; i < array_length(clients); i++) {
		if (clients[i] == sock) {
			idx = i;
			break;
		}
	}
	network_destroy(clients[idx]);
	array_delete(clients, idx, 1);
	
	if (!ds_map_exists(client_id_to_lobby, sock)) return;
	
	
	var lobby = client_id_to_lobby[? sock];
	remove_from_lobby(sock);
	if (lobby.host == sock) {
		// session host disconnected
		packet_send_multiple(lobby.players, packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_HOST_DISCONNECTED));
		lobby_close(lobby);
	} else {
		packet_send(lobby.host, packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_CLIENT_DISCONNECTED, {client_id: sock}));
	}
}

handle_create_lobby = function(sock, data) {
	if (ds_map_exists(client_id_to_lobby, sock)) return;
	
	var lobby = new Lobby(sock);
	array_push(lobbies, lobby);
	var code = generateLobbyCode();
	while (ds_map_exists(lobby_code_to_lobby, code)) {
		code = generateLobbyCode();
	}
	
	lobby.code = code;
	lobby.name = data.name;
	lobby.max_player_count = data.max_player_count;
	lobby.public = data.public;
	
	ds_map_add(lobby_code_to_lobby, code, lobby);
	ds_map_add(client_id_to_lobby, sock, lobby);
	
	packet_send(sock, packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_HOST, {client_id: sock}));
	packet_send(sock, packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_LOBBY_CODE, {code: code}));
}

handle_join_lobby = function(sock, data) {
	if (ds_map_exists(client_id_to_lobby, sock)) {
		packet_send(sock, packet_create_server(NWTarget.SERVER, true, PacketType.HOST_INFO_CONNECTION_REJECTED,
			{message: "Already in a lobby."}));
		return;
	}
	if (!ds_map_exists(lobby_code_to_lobby, data.code)) {
		packet_send(sock, packet_create_server(NWTarget.SERVER, true, PacketType.HOST_INFO_CONNECTION_REJECTED,
			{message: "Lobby doesn't exist."}));
		return;
	}
	
	var lobby = lobby_code_to_lobby[? data.code];
	
	if (array_length(lobby.players) == lobby.max_player_count) {
		packet_send(sock, packet_create_server(NWTarget.SERVER, true, PacketType.HOST_INFO_CONNECTION_REJECTED,
			{message: "Lobby is full."}));
		return;
	}
	
	array_push(lobby.players, sock);
	ds_map_add(client_id_to_lobby, sock, lobby);
	packet_send(lobby.host, packet_create_server(NWTarget.SERVER, true, PacketType.SV_INFO_CONNECTION_REQUEST,
		{client_id: sock}));
}

handle_remove_from_lobby = function(sock, data) {
	if (!ds_map_exists(client_id_to_lobby, sock)) return;
	
	var lobby = client_id_to_lobby[? sock];
	
	if (sock != lobby.host) return;
	
	if (!array_contains(lobby.players, data.player_id)) return;
	
	remove_from_lobby(data.player_id);
}

send_lobby_list = function(sock, data) {
	
}