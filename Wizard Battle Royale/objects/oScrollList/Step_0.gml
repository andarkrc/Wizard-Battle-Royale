if (!enabled || !visible || !layer_get_visible(layer)) exit;

if (last_buttons_number != array_length(buttons)) {
	update_contents();
	last_buttons_number = array_length(buttons);	
}

var _dt = delta_time / 1000000;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (hover_check(mx, my) && can_scroll) {
	var buttons_num = array_length(displayed_buttons);
	var needed_space = top_padding + buttons_num * (gap + scroll_button_height);
	var scroll_distance = needed_space - list_height;
	if (scroll_distance > 0) {
		var scroll_speed = scroll_button_height * 20 * _dt;
		var scroll_dir = mouse_wheel_up() - mouse_wheel_down();
		if (scroll_dir != 0) {
			scroll_offset = clamp(scroll_offset + scroll_dir * scroll_speed, -scroll_distance, 0);
			update_buttons_scroll();
		}
	}
}