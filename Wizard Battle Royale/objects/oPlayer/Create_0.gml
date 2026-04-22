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
	SIDE_FALLING
}

state = State.IDLE;
old_state = state;

damaged = false;

ts_reset_damage = time_source_create(time_source_game, 0.3, time_source_units_seconds, function(){damaged = false;});