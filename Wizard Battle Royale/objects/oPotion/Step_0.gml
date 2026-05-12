var _dt = delta_time / 1000000;

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

var distance_horizontal = horizontal_speed * _dt;
var distance_vertical = vertical_speed * _dt;

var collisions = move_and_collide(distance_horizontal, distance_vertical, oCollisionBox);
	
var collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, true);
	
if (collision_down == noone) {
	vertical_speed += g * _dt;
} else {
	vertical_speed = 0;
}

can_be_collected = (horizontal_speed == 0 && vertical_speed == 0);