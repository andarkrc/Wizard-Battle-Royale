var collisions_top = [oCollisionBox, oCollisionBoxTopOnly];
	
var collision_down = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom + 1, collisions_top, false, false);

if (state != State.DASHING) {
	override_horizontal = false;
	override_vertical = false;
}

if (id_ == oClientHandler.client_id && oGameplayHandler.state != GameState.PREGAME_LOADING) {
	var _dt = delta_time / 1000000;
	var movement_inactive = (state == State.DASHING);
	combat_active = (oGameplayHandler.state == GameState.GAME) || 1;
	var input_px = keyboard_check(ord("D"));
	var input_nx = keyboard_check(ord("A"));
	var input_py = keyboard_check(ord("S"));
	var input_ny = keyboard_check(ord("W"));
	var input_x = input_px - input_nx;
	var input_y = input_py - input_ny;
	
	input_x *= !movement_inactive;
	input_y *= !movement_inactive;
	
	horizontal_speed = 0;
	if (input_x != 0) {
		horizontal_speed = input_x * move_speed;
	}
	
	if (keyboard_check_pressed(vk_shift) && !movement_inactive && current_dashes > 0) {
		if (collision_down == noone || (collision_down.object_index == oCollisionBoxTopOnly && input_y > 0)) {
			var dir = 90;
			if (input_x != 0 || input_y != 0) {
				dir = darctan2(-input_y, input_x);
			}
			dash(dir);
		}
	}
	
	if (collision_down && state != State.DASHING) {
		current_dashes = total_dashes;
	}
	
	if (keyboard_check_pressed(vk_space) && !movement_inactive) {
		if (collision_down != noone) {
			vertical_speed = -jump_power;
			state = State.JUMPING;
		}
	}
	
	var holding_throwable = (potion != Potion.NONE && array_contains(global.throwable_potions, potion));
	
	if (mouse_check_button_pressed(mb_left) && selected_spell >= 0 && selected_spell < array_length(spells) && combat_active && !holding_throwable) {
		if (spells[selected_spell].type != Spell.NONE) {
			var dir = point_direction(x, y - sprite_height / 2, mouse_x, mouse_y);
			packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_SPELLCAST,
				{slot_index: selected_spell, direction: dir}));
		}
	}
	
	var old_selected_spell = selected_spell;
	if (combat_active && keyboard_check_pressed(ord("1"))) {
		selected_spell = 0;
	}
	
	if (combat_active && keyboard_check_pressed(ord("2"))) {
		selected_spell = 1;
	}
	
	if (combat_active && keyboard_check_pressed(ord("3"))) {
		selected_spell = 2;
	}
	
	if (combat_active && keyboard_check_pressed(ord("4"))) {
		selected_spell = 3;
	}
	
	if (combat_active && keyboard_check_pressed(ord("5"))) {
		selected_spell = 4;
	}
	
	if (selected_spell >= array_length(spells)) {
		selected_spell = old_selected_spell;
	}
	
	var collectible = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, [oPotion, oSpellPlatform, oChest], false, false);
	
	if (instance_exists(prev_focused)) {
		prev_focused.focused = false;
		prev_focused = noone;
	}
	
	with (collectible) {
		focused = true;
	}
	
	prev_focused = collectible;
	
	if (collectible != noone && keyboard_check_pressed(ord("E")) && collectible.can_be_collected) {
		collectible.request_loot();
	}
	
	for (var i = 0; i < array_length(spells); i++) {
		if (spells[i].cooldown > 0) {
			spells[i].cooldown -= _dt;
			if (spells[i].cooldown < 0) {
				spells[i].cooldown = 0;
			}
		}
	}
	
	var spike_collision = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, oSpikesSimple, false, false);
	
	if (spike_collision != noone && !hit_trap) {
		hit_trap = true;
		packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_HIT_TRAP));
	}
	
	if (potion != Potion.NONE && mouse_check_button_released(mb_right)) {
		var target_x = mouse_x;
		var target_y = mouse_y;
		
		packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_THROW_POTION, {target_x: target_x, target_y: target_y}));
	}
	
	if (potion != Potion.NONE && keyboard_check_pressed(ord("F"))) {
		packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_CONSUME_POTION));
	}
	
	if (devil_pact_active) {
		devil_pact_time -= _dt;
		if (devil_pact_time <= 0) {
			devil_pact_active = false;
			hp = min(hp + devil_pact_hp_taken, 100);
			devil_pact_completed = true;
		}
	}
	
	if (devil_pact_completed && hp <= 50 && hp > 0) {
		hp = 100;
		devil_pact_completed = false;
	}
	
	if (old_state != state) {
		packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_INFO_PLAYER_STATE, {state: state, direction: image_xscale}));
	}
	
	if (old_state != state && state == State.DASHING) {
		dash_sound = audio_play_sound_at(sndDash, x, y, 0, global.fallof_ref, global.fallof_max, 1, false, 1);
	}
	
	if (horizontal_speed != 0 || vertical_speed != 0) {
		packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_INFO_PLAYER_POSITION, {x: x, y: y}));
	}
	
	old_state = state;
}

// after input detection move the player
move();

if (state  == State.DASHING) {
	
}
else if (collision_down == noone && state != State.JUMPING) {
	state = (horizontal_speed != 0) ? State.SIDE_FALLING : State.FALLING;
} else {
	if (horizontal_speed != 0) {
		state = State.RUNNING;
	} else {
		state = State.IDLE;
	}
}

if (state == State.RUNNING || state == State.SIDE_FALLING || state == State.DASHING) {
	image_xscale = (horizontal_speed < 0) ? -image_scale : image_scale;
} else {
	image_xscale = image_scale;
}

if (state == State.DASHING) {
	var particles = particle_get_type(psPlayerDash, 0);
	part_type_scale(particles, image_xscale, image_yscale);
	part_type_size(particles, 1, 1, 0, 0.05);
	part_type_life(particles, 5, 10);
	part_type_sprite(particles, sprite_dashing, false, false, false);
	part_type_alpha3(particles, 0.25, 0.25, 0.25);
	part_particles_create(oGameplayHandler.particle_system, x, y, particles, 1);
}

if (state == State.RUNNING && !audio_is_playing(walking_sound)) {
	walking_sound = audio_play_sound_at(sndWalk, x, y, 0, global.fallof_ref, global.fallof_max, 1, false, 1);
}
