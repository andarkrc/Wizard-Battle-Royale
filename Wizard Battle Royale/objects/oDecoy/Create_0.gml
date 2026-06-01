event_inherited();
run_direction = 1; // Will be set on spawn: -1 (left) or 1 (right)
source_name = "";  // Copy of the spawning player's name

move_speed = 2.5 * METER;


dash_duration = 0.25;
dash_speed = 2.5 * METER / dash_duration;

image_scale = 1.5;
image_xscale = image_scale;
image_yscale = image_scale;

image_alpha = 0.6;

state = State.RUNNING;
mask_index = sPlayerIdleRed;

lifetime = global.decoy_duration;
next_dash_timer = random(1);
is_dashing = false;
jump_power = 6.5 * METER;
next_jump_timer = random(1);
override_horizontal = true;
