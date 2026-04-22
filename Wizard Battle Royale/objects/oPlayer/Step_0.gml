if (id_ == oClientHandler.client_id) {
	var _dt = delta_time / 1000000;
	var move_side = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	
	if (vertical_speed > 0) {
		var collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + vertical_speed, oCollisionBox, false, true);
		if (collision_down != noone) {
			while (collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, oCollisionBox, false, true) == noone) {
				y += 1;
			}
			vertical_speed = 0;
		}
	}
	
	var collisions_vertical = move_and_collide(0, vertical_speed, oCollisionBox);
	
	var collisions_side = move_and_collide(move_side * move_speed * _dt, 0, oCollisionBox);
	
	if (vertical_speed < 0 && array_length(collisions_vertical) != 0) {
		vertical_speed = 0;
	}
	
	var collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, oCollisionBox, false, true);
	
	if (collision_down == noone) {
		vertical_speed += g * _dt;
	} else {
		vertical_speed = 0;
	}
	
	if (keyboard_check(ord("W"))) {
		if (collision_down != noone) {
			vertical_speed = -jump_power;
			state = State.JUMPING;
		}
	}
	
	if (collision_down == noone && state != State.JUMPING) {
		state = (move_side != 0) ? State.SIDE_FALLING : State.FALLING;
	} else {
		if (move_side != 0 && array_length(collisions_side) == 0) {
			state = State.RUNNING;
		} else {
			state = State.IDLE;
		}
	}
	
	if (state == State.RUNNING || state == State.SIDE_FALLING) {
		image_xscale = (move_side == -1) ? -1 : 1;
	} else {
		image_xscale = 1;
	}
	
	if (array_length(collisions_side) == 0 || array_length(collisions_vertical) != 0) {
		packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_INFO_PLAYER_POSITION, {x: x, y: y}));
	}
	
	if (old_state != state) {
		packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_INFO_PLAYER_STATE, {state: state, direction: image_xscale}));
	}
	
	if (mouse_check_button_pressed(mb_left)) {
		var dir = point_direction(x, y - sprite_height / 2, mouse_x, mouse_y);
		packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_SPELLCAST,
		{x: x, y: y - sprite_height / 2, direction: dir}));
	}
	
	
	old_state = state;
}
