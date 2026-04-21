draw_sprite_ext(sprite_index, selected || can_write, x, y, width / sprite_width, height / sprite_height, 0, c_white, 1);


var display_text = text;
draw_setup(c_white, 1, fa_center, fa_middle, font);
if (text == "") {
	display_text = ghost_text;
	draw_setup(c_white, 0.8, fa_center, fa_middle);
}


draw_text(x + width / 2, y + height / 2, display_text);


var cursor_x = string_width(string_copy(text, 1, cursor_index - 1));
var bar_width = string_width("|");
if (can_write && blink) {
	draw_text(x + width / 2 + cursor_x - bar_width / 2, y + height / 2, "|");
}






