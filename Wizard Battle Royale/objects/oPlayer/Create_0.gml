id_ = -1;
name = "";

move_speed = 2.5 * METER;

vertical_speed = 0;
g = 20 * METER;

jump_power = 6 * METER;

dash_duration = 0.25;
dash_speed = 2 * METER / dash_duration;
dash_direction = 0;
total_dashes = 3;
current_dashes = 3;

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
mask_index = sPlayerIdle;

damaged = false;

ts_reset_damage = time_source_create(time_source_game, 0.3, time_source_units_seconds, function(){damaged = false;});

enum Spell {
	NONE,
	FIREBALL,
	WIND_SLASH,
	SHIELD
}

SpellSlot = function() constructor {
	type = Spell.NONE;
	casts_remaining = 1;
	cooldown = 0;
}

max_spell_count = 5;
min_spell_count = 1;

selected_spell = -1;

spells = [new SpellSlot(), new SpellSlot()];

cast_spell = function() {
	
}
