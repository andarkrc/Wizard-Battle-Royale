var _dt = delta_time / 1000000;

// Countdown lifetime
lifetime -= _dt;
if (lifetime <= 0) {
	instance_destroy();
	return;
}

// Collision setup
var collisions_all = [oCollisionBox, oCollisionBoxTopOnly];
var collisions_full = oCollisionBox;
var collisions_top = [oCollisionBox, oCollisionBoxTopOnly];

// Vertical collision
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

// Movement
var distance_horizontal = run_direction * move_speed * _dt;
var distance_vertical = vertical_speed * _dt;
if (is_dashing) {
	distance_horizontal = run_direction * dash_speed * _dt;
	distance_vertical = 0;
}

var collisions = move_and_collide(distance_horizontal, distance_vertical, oCollisionBox);

// Ground check
var collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, true);

if (collision_down == noone) {
	vertical_speed += g * _dt;
} else {
	vertical_speed = 0;
	if (!is_dashing) {
		while (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, collisions_all, false, false) != noone) {
			y -= 1;
		}
	}
}

// On ground: count down jump timer, then jump
if (!is_dashing && collision_down != noone) {
	next_jump_timer -= _dt;
	if (next_jump_timer <= 0) {
		vertical_speed = -jump_power;
		state = State.JUMPING;
		next_jump_timer = random(1);
		next_dash_timer = random_range(0.1, 0.3); // Dash shortly after jumping
	}
}

// In air: count down dash timer, then dash
if (!is_dashing && collision_down == noone) {
	next_dash_timer -= _dt;
	if (next_dash_timer <= 0) {
		is_dashing = true;
		state = State.DASHING;
		call_later(dash_duration, time_source_units_seconds,
			function() {
				is_dashing = false;
				state = State.FALLING;
				vertical_speed = 0;
				next_dash_timer = random(1);
			}
		);
	}
}
// State management
if (state == State.DASHING) {
	// Keep dashing state
} else if (collision_down == noone && state != State.JUMPING) {
	state = State.SIDE_FALLING;
} else if (collision_down != noone) {
	state = State.RUNNING;
}

// Facing direction
image_xscale = (run_direction < 0) ? -image_scale : image_scale;

// Dash particles
if (is_dashing) {
	var particles = particle_get_type(psPlayerDash, 0);
	part_type_scale(particles, image_xscale, image_yscale);
	part_type_size(particles, 1, 1, 0, 0.05);
	part_type_life(particles, 5, 10);
	part_particles_create(oGameplayHandler.particle_system, x, y, particles, 1);
}
