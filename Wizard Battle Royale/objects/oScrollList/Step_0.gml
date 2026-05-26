if (!enabled) exit;


var _dt = delta_time / 1000000;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (hover_check(mx, my)) {
	var buttons_num = array_length(displayed_buttons);
	var needed_space = top_padding + (buttons_num - 1) * gap + buttons_num * scroll_button_height;
	var scroll_distance = needed_space - sprite_height;
	if (scroll_distance > 0) {
		var scroll_speed = scroll_button_height * 20 * _dt;
		var scroll_dir = mouse_wheel_up() - mouse_wheel_down();
		if (scroll_dir != 0) {
			scroll_offset = clamp(scroll_offset + scroll_dir * scroll_speed, -scroll_distance, 0);
			update_buttons_scroll();
		}
	}
}