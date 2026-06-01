var _dt = delta_time / 1000000;

// Countdown lifetime
lifetime -= _dt;
if (lifetime <= 0) {
	instance_destroy();
	return;
}

var collisions_top = [oCollisionBox, oCollisionBoxTopOnly];

var collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, false);


// Movement
if (!is_dashing) {
	horizontal_override = run_direction * move_speed;
} else {
	horizontal_override = run_direction * dash_speed;
}
if (is_dashing) {
	vertical_override = 0;
	override_vertical = true;
} else {
	override_vertical = false;
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

move();

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
