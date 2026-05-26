id_ = -1;
name = "";

move_speed = 2.5 * METER;

vertical_speed = 0;
g = 20 * METER;

jump_power = 6 * METER;

dash_duration = 0.25;
dash_speed = 2.5 * METER / dash_duration;
dash_direction = 0;
total_dashes = 1;
current_dashes = 1;

hp = 100;

enum State {
	IDLE,
	BREATHING,
	RUNNING,
	JUMPING,
	FALLING,
	SIDE_FALLING,
	DASHING
}

image_scale = 1.5;

image_xscale = image_scale;
image_yscale = image_scale;

state = State.IDLE;
old_state = state;
mask_index = sPlayerIdle;

damaged = false;

ts_reset_damage = time_source_create(time_source_game, 0.3, time_source_units_seconds, function(){damaged = false;});

combat_active = false;
max_spell_count = 5;
min_spell_count = 1;

selected_spell = 0;

spells = [new SpellSlot(), new SpellSlot()];

potion = Potion.NONE;

drink_potion = function() {
	switch (potion) {
		case Potion.SPEED:
			move_speed += 1 * METER;
			if (move_speed > 5.5 * METER) {
				move_speed = 5.5 * METER;
			}
			break;
		
		case Potion.INVISIBILITY:
			if (id_ == oClientHandler.client_id) {
				image_alpha = 0.7;
			} else {
				image_alpha = 0.1;
			}
			time_source_stop(make_visibile_timer);
			time_source_start(make_visibile_timer);
			break;
		
		case Potion.DASHING:
			total_dashes++;
			if (total_dashes > 5) {
				total_dashes = 5;
			}
			break;
		
		case Potion.LIMITS:
			// The effect is not handled here.
			// Check the HOST_SYNC_SPELL_SLOT_NUMBER callback in game handler.
			break;
			
		case Potion.CLEANSING:
			blinded = false;
			blind_opacity = 0;
			time_source_stop(remove_blinding_timer);
			break;

		case Potion.TEN_HP:
			hp = min(hp + 10, 150);
			break;

		case Potion.HEAL_HALF:
			hp = hp + ceil((100 - hp) / 2.0);
			break;
		
		case Potion.DECOY:
			// Effect handled via HOST_SYNC_DECOY_SPAWN callback
			break;
		
		default:
			break;
	}
	potion = Potion.NONE;
}

prev_focused = noone;

make_visibile_timer = time_source_create (
						time_source_game, 
						global.invisibility_duration, 
						time_source_units_seconds,
						function () {
							image_alpha = 1;
						}
						);

blinded = false;
blind_opacity = 20;

remove_blinding_timer = time_source_create (
						time_source_game,
						global.blinding_effect_duration,
						time_source_units_seconds,
						function () {
							blinded = false;
						}
						);

reversed = false;

remove_reverse_timer = time_source_create (
						time_source_game,
						global.reverse_effect_duration,
						time_source_units_seconds,
						function () {
							reversed = false;
							var camera = view_get_camera(0);
							camera_set_view_angle(camera, 0);
							with (oPotion) {
								if (potion == Potion.REVERSE && broken) {
									cloud_hit_local = false;
								}
							}
						}
						);

