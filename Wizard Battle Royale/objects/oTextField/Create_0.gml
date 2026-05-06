type = "";

font = global.default_font;

text = "";

enabled = true;
hovered = false;

ghost_text = "";

can_write = false;

cursor_index = 1;

blink = true;

delete_delay = false;
delete_delay_time = 0.5;

blink_state_change = function() {
	blink = !blink;
}

blink_state_timer = time_source_create(time_source_game, 0.5, time_source_units_seconds, blink_state_change, [], -1);

delete_delay_call = undefined;

can_delete = function() {
	if (keyboard_check_pressed(vk_backspace)) {
		delete_delay_time = 0.5;
		return true;
	}
	if (keyboard_check(vk_backspace) && !delete_delay) {
		delete_delay_time = 0.05;
		return true;
	}
	return false;
}

action = function() {
	
}
