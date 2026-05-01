var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
hovered = point_in_rectangle(mx, my, x, y, x + sprite_width, y + sprite_height);


if (mouse_check_button_released(mb_left) && hovered)
{
	click_action();
}