// Inherit the parent event
event_inherited();
if (!enabled || !visible) exit;
if (mouse_check_button_pressed(mb_right) && hovered) {
	right_click_action();
}