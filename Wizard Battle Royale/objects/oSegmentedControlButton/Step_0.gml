if (!enabled || !visible) exit;

if (mouse_check_button_pressed(mb_left) && hovered) {
	unselect_group_members();
	selected = true;
	click_action();
}