if (!enabled) exit;
draw_sprite_ext(sprite_index, hovered || selected, x, y, image_xscale, image_yscale, 0, c_white, 1);

if (instance_exists(parent)) {
	var scroll_distance = total_list_space - parent.list_height;
	
	
	if (scroll_distance > 0) {
		var bar_size = parent.list_height / total_list_space * (sprite_height - 10);
		var bar_pos = -parent.scroll_offset / total_list_space;
		draw_sprite_ext(sScrollBar, 0, x + 5, y + bar_pos * (sprite_height - 10) + 5, sprite_width - 10, bar_size, 0, c_white, 1);
	} else {
		draw_sprite_ext(sScrollBar, 0, x + 5, y + 5, sprite_width - 10, sprite_height - 10, 0, c_white, 1);
	}
}