client = network_create_socket(network_socket_udp);

lobbies = [];

request_new_lobbies = function() {
	lobbies = [];
	packet_send_udp(client, global.external_server_ip, global.external_server_port_udp, 
	packet_create(NWTarget.SERVER, PacketType.CL_REQ_LOBBY_LIST));
}