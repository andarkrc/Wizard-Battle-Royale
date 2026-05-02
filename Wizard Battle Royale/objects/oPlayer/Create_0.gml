id_ = -1;
name = "";

move_speed = sprite_width * 3;

vertical_speed = 0;
g = 10;

jump_power = 6;

enum State {
	IDLE,
	BREATHING,
	RUNNING,
	JUMPING,
	FALLING,
	SIDE_FALLING,
	DASHING
}

state = State.IDLE;
old_state = state;

damaged = false;

ts_reset_damage = time_source_create(time_source_game, 0.3, time_source_units_seconds, function(){damaged = false;});

dash_max_charges = 2;
dash_charges = dash_max_charges;
dash_distance_pixels = 250;
dash_duration_seconds = 1;
dash_cooldown_seconds = 8;

dash_dir_x = 0;
dash_dir_y = 0;
dash_speed = 0;
stored_vertical_speed = 0;

dash_error_msg_timer = 0;

ts_dash_end = time_source_create(time_source_game, dash_duration_seconds, time_source_units_seconds, function() {
	if (state == State.DASHING) {
		state = State.FALLING;
		vertical_speed = stored_vertical_speed;
		image_speed = 1;
	}
});

ts_dash_recharge = time_source_create(time_source_game, dash_cooldown_seconds, time_source_units_seconds, function() {
	if (dash_charges < dash_max_charges) {
		dash_charges += 1;
		if (dash_charges < dash_max_charges) {
			time_source_start(ts_dash_recharge);
		}
	}
});