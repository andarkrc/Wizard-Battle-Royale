
if (id_ == oClientHandler.client_id) {
	var move_up = keyboard_check(ord("S")) - keyboard_check(ord("W"));
	var move_side = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	
	if (move_up != 0) {
		y += move_up * move_speed * delta_time / 1000000;
	}
	
	if (move_side != 0) {
		x += move_side * move_speed * delta_time / 1000000;
	}
	
	if (move_up != 0 || move_side != 0) {
		packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_INFO_PLAYER_POSITION, {x: x, y: y}));
	}
}