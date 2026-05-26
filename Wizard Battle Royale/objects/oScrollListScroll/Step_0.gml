if (!enabled || !visible) exit;
	
if (mouse_check_button_pressed(mb_left) && hovered) {
	selected = true;
}

if (mouse_check_button_released(mb_left) && selected) {
	selected = false;
}

if (instance_exists(parent)) {
	with (parent) {
		var buttons_num = array_length(displayed_buttons);
		other.total_list_space = top_padding + (buttons_num - 1) * gap + buttons_num * scroll_button_height;
	}
	
	if (selected) {
		var my = device_mouse_y_to_gui(0);
		
		var scroll_distance = total_list_space - parent.list_height;
		var bar_pos = clamp((my - y + 5) / (sprite_height - 10), 0, 1);
		
		if (scroll_distance > 0) {
			parent.scroll_offset = -bar_pos * scroll_distance;
			parent.update_buttons_scroll();
		}
		parent.can_scroll = false;
	} else {
		parent.can_scroll = true;
	}
}