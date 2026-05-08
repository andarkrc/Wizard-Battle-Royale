if (id_ == oClientHandler.client_id) {
	var _dt = delta_time / 1000000;
	var movement_inactive = state == State.DASHING;
	var input_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	var input_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));
	var collisions_side = [];
	var collisions_vertical = [];
	
	input_x = input_x * !movement_inactive;
	input_y = input_y * !movement_inactive;

	var collisions_all = [oCollisionBox, oCollisionBoxTopOnly]
	var collisions_full = oCollisionBox;
	var collisions_top = [oCollisionBox, oCollisionBoxTopOnly];
		
	if (vertical_speed > 0) {
		var collision_vertical = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + vertical_speed * _dt, collisions_top, false, true);
		if (collision_vertical != noone) {
			while (collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, false) == noone) {
				y += 1;
			}
			vertical_speed = 0;
		}
	} else if (vertical_speed < 0) {
		var collision_vertical = collision_rectangle(bbox_left, bbox_top + vertical_speed * _dt, bbox_right, bbox_top, collisions_full, false, false);
		if (collision_vertical != noone) {
			while (collision_rectangle(bbox_left, bbox_top - 1, bbox_right, bbox_top, collisions_full, false, false) == noone) {
				y -= 1;
			}
			vertical_speed = 0;
		}
	}
	
	var distance_horizontal = input_x * move_speed * _dt;
	var distance_vertical = vertical_speed * _dt;
	if (state == State.DASHING) {
		distance_horizontal = dash_speed * dcos(dash_direction) * _dt;
		distance_vertical = dash_speed * dsin(-dash_direction) * _dt;
	}
	
	var collisions = move_and_collide(distance_horizontal, distance_vertical, oCollisionBox);
	
	if (vertical_speed < 0 && array_length(collisions_vertical) != 0) {
		vertical_speed = 0;
	}
	
	var collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, true);
	
	if (collision_down == noone) {
		vertical_speed += g * _dt;
	} else {
		vertical_speed = 0;
		current_dashes = total_dashes;
		if (state != State.DASHING) {
			while (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, collisions_all, false, false) != noone) {
				y -= 1;
			}
		}
	}
	
	if (keyboard_check_pressed(vk_shift) && !movement_inactive && current_dashes > 0) {
		if (collision_down == noone) {
			state = State.DASHING;
			current_dashes -= 1;
			if (input_x == 0 && input_y == 0) {
				dash_direction = 90;
			} else {
				dash_direction = point_direction(0, 0, input_x, input_y);
			}
			call_later(dash_duration, time_source_units_seconds,
				function() {
					state = State.FALLING;
					vertical_speed = 0;
				}
			);
		}
	}
	
	if (keyboard_check_pressed(ord("W")) && !movement_inactive) {
		if (collision_down != noone) {
			vertical_speed = -jump_power;
			state = State.JUMPING;
		}
	}
	
	if (state  == State.DASHING) {
		
	}
	else if (collision_down == noone && state != State.JUMPING) {
		state = (input_x != 0) ? State.SIDE_FALLING : State.FALLING;
	} else {
		if (input_x != 0) {
			state = State.RUNNING;
		} else {
			state = State.IDLE;
		}
	}
	
	if (state == State.RUNNING || state == State.SIDE_FALLING || state == State.DASHING) {
		image_xscale = (distance_horizontal < 0) ? -1 : 1;
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
		cast_spell();
	}
	
	if (keyboard_check_pressed(ord("1"))) {
		selected_spell = 0;
	}
	
	if (keyboard_check_pressed(ord("2"))) {
		selected_spell = 1;
	}
	
	if (keyboard_check_pressed(ord("3"))) {
		selected_spell = 2;
	}
	
	if (keyboard_check_pressed(ord("4"))) {
		selected_spell = 3;
	}
	
	if (keyboard_check_pressed(ord("5"))) {
		selected_spell = 4;
	}
	
	old_state = state;
}

if (state == State.DASHING) {
	var particles = particle_get_type(psPlayerDash, 0);
	part_type_scale(particles, image_xscale, image_yscale);
	part_type_size(particles, 1, 1, 0, 0.05);
	part_type_life(particles, 5, 10);
	part_particles_create(oGameplayHandler.particle_system, x, y, particles, 1);
}
