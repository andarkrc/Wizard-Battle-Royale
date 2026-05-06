if (!enabled) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

hovered = point_in_rectangle(mx, my, x, y, x + sprite_width, y + sprite_height);

if (mouse_check_button_pressed(mb_left)) {
	can_write = hovered;
	if (can_write) {
		time_source_start(blink_state_timer);
	} else {
		blink = true;
		time_source_stop(blink_state_timer);
		action();
	}
}

if (keyboard_check_released(vk_backspace)) {
	if (time_source_exists(delete_delay_call)) {
		call_cancel(delete_delay_call);
	}
}

if (can_write) {
	if (keyboard_check_pressed(vk_enter)) {
		can_write = false;
		action();
	} else if (can_delete()) {
		if (cursor_index > 1) {
			text = string_delete(text, cursor_index - 1, 1);
			cursor_index--;
			delete_delay = true;
			delete_delay_call = call_later(delete_delay_time, time_source_units_seconds, function(){delete_delay = false;});
		}
	} else if (keyboard_check_pressed(vk_left)) {
		cursor_index = clamp(cursor_index - 1, 1, string_length(text) + 1);
	} else if (keyboard_check_pressed(vk_right)) {
		cursor_index = clamp(cursor_index + 1, 1, string_length(text) + 1);
	} else if (keyboard_check(vk_control) && keyboard_check_pressed(ord("V"))) {
		keyboard_string = clipboard_get_text();
	}

	//show_debug_message($"Current typing: {keyboard_string}");
	if (string_length(keyboard_string) != 0) {
		text = string_insert(keyboard_string, text, cursor_index);
		cursor_index += string_length(keyboard_string);
		keyboard_string = "";
	}
}