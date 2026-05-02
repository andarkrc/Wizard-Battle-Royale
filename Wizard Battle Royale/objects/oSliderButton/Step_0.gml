if (!enabled) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
hovered = point_in_rectangle(mx, my, x, y, x + sprite_width, y + sprite_height);

if (mouse_check_button_pressed(mb_left) && hovered) {
	selected = true;
}

if (mouse_check_button_released(mb_left) && selected) {
	selected = false;
	update_action();
}

if (selected) {
	slider_value = clamp((mx - x) / sprite_width, 0, 1);
	slider_value = min_value + slider_value * (max_value - min_value);
	slider_value = floor(slider_value / step_value) * step_value;
}

slider_value = clamp(slider_value, min_value, max_value);