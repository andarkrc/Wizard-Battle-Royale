g = 20 * METER;

bouncy = false;

// force can act as acceleration for now xd
horizontal_force = 0;
vertical_force = 0;

horizontal_speed = 0;
vertical_speed = 0;

horizontal_override = 0;
vertical_override = 0;

horizontal_speed_max = 0;
vertical_speed_max = 0;

override_horizontal = false;
override_vertical = false;

can_collide_with_top_only = true;

move = function() {
	var _dt = delta_time / 1000000;
	
	var collisions_top = [oCollisionBox, oCollisionBoxTopOnly];
	var collisions_full = [oCollisionBox];
	
	if (can_collide_with_top_only == false) {
		collisions_top = [oCollisionBox];
	}
	
	var collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, false);
	var collision_top = collision_rectangle(bbox_left, bbox_top - 1, bbox_right, bbox_top, collisions_full, false, false);
	var collision_left = collision_rectangle(bbox_left - 1, bbox_top, bbox_right, bbox_bottom, collisions_full, false, false);
	var collision_right = collision_rectangle(bbox_left, bbox_top, bbox_right + 1, bbox_bottom, collisions_full, false, false);
	
	horizontal_speed += horizontal_force * _dt;
	vertical_speed += vertical_force * _dt;
	
	if (override_vertical) {
		vertical_speed = vertical_override;
	}
	
	if (override_horizontal) {
		horizontal_speed = horizontal_override;
	}
	
	if (vertical_speed > 0) {
		var collision_vertical = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + vertical_speed * _dt, collisions_top, false, true);
		if (collision_vertical != noone) {
			while (collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, false) == noone) {
				y += 1;
			}
			if (bouncy) {
				vertical_speed *= -1;
			} else {
				vertical_speed = 0;
			}
		}
	} else if (vertical_speed < 0) {
		var collision_vertical = collision_rectangle(bbox_left, bbox_top + vertical_speed * _dt, bbox_right, bbox_top, collisions_full, false, false);
		if (collision_vertical != noone) {
			while (collision_rectangle(bbox_left, bbox_top - 1, bbox_right, bbox_top, collisions_full, false, false) == noone) {
				y -= 1;
			}
			if (bouncy) {
				vertical_speed *= -1;
			} else {
				vertical_speed = 0;
			}
		}
	}
	
	if (horizontal_speed > 0) {
		if (collision_right != noone) {
			horizontal_speed = 0;
		}
	} else if (horizontal_speed < 0) {
		if (collision_left != noone) {
			horizontal_speed = 0;
		}
	}
	
	var distance_horizontal = horizontal_speed * _dt;
	var distance_vertical = vertical_speed * _dt;
	
	var collisions = move_and_collide(distance_horizontal, distance_vertical, oCollisionBox);
	
	collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, false); 
	
	if (collision_down == noone) {
		vertical_speed += g * _dt;
	} else {
		vertical_speed = 0;
		
		while (collision_line(bbox_left, bbox_bottom, bbox_right, bbox_bottom, oCollisionBoxTopOnly, false, false)) {
			y -= 1;
		}
	}
}