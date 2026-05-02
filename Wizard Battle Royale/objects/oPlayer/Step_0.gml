if (id_ == oClientHandler.client_id) {
	var _dt = delta_time / 1000000;
	var move_side = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	var collisions_side = [];
	var collisions_vertical = [];
	
	if (dash_error_msg_timer > 0) dash_error_msg_timer -= _dt;
	
	var input_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));
	
	var ctrl_pressed = keyboard_check_pressed(vk_lcontrol);
	var ctrl_held = keyboard_check(vk_lcontrol);
	var dir_pressed = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("S")) || keyboard_check_pressed(ord("D"));
	var dir_held = (move_side != 0 || input_y != 0);
	
	var dash_triggered = false;
	if ((ctrl_pressed && dir_held) || (ctrl_held && dir_pressed)) {
		dash_triggered = true;
	}
	
	if (dash_triggered && state != State.DASHING) {
		if (dash_charges > 0) {
			stored_vertical_speed = vertical_speed;
			state = State.DASHING;
			
			var len = point_distance(0, 0, move_side, input_y);
			dash_dir_x = move_side / len;
			dash_dir_y = input_y / len;		

			dash_speed = dash_distance_pixels / dash_duration_seconds;
			vertical_speed = 0;
			image_speed = 0;
			if (dash_dir_x != 0) {
				image_xscale = (dash_dir_x < 0) ? -1 : 1;
			}
			
			dash_charges -= 1;
			time_source_start(ts_dash_end);
			if (time_source_get_state(ts_dash_recharge) != time_source_state_active) {
				time_source_start(ts_dash_recharge);
			}
		} else {
			dash_error_msg_timer = 2;
		}
	}
	
	if (state == State.DASHING) {
		collisions_side = move_and_collide(dash_dir_x * dash_speed * _dt, dash_dir_y * dash_speed * _dt, oCollisionBox);
	} else {
		if (vertical_speed > 0) {
			var collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + vertical_speed, oCollisionBox, false, true);
			if (collision_down != noone) {
				while (collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, oCollisionBox, false, true) == noone) {
					y += 1;
				}
				vertical_speed = 0;
			}
		}
		
		collisions_vertical = move_and_collide(0, vertical_speed, oCollisionBox);
		collisions_side = move_and_collide(move_side * move_speed * _dt, 0, oCollisionBox);
		
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
