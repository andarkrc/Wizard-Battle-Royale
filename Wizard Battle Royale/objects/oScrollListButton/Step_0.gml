// Inherit the parent event
event_inherited();

if (!enabled || !visible || !layer_get_visible(layer)) exit;
	
if (mouse_check_button_pressed(mb_right) && hovered) {
	right_click_action();
}