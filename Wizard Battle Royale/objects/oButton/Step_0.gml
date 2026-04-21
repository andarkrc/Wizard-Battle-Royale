var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
selected = point_in_rectangle(mx, my, x, y, x + width, y + height);


if (mouse_check_button_released(mb_left) && selected)
{
	click_action();
}