if (!enabled || !visible || !layer_get_visible(layer)) exit;

if (mouse_check_button_pressed(mb_left) && hovered) {
	state = !state;
	click_action();
}