// Inherit the parent event
event_inherited();

if (hovered && selected && mouse_check_button_pressed(mb_left))
{
	right_click_action();	
}
selected = (global.lobby_code == data.code);