if (!enabled) exit;

draw_sprite_ext(sprite_index, hovered || can_write, x, y, image_xscale, image_yscale, 0, c_white, 1);

var display_text = text;
draw_setup(c_white, 1, fa_center, fa_middle, font);
if (text == "") {
	display_text = ghost_text;
	draw_setup(c_white, 0.8, fa_center, fa_middle);
}


draw_text(x + sprite_width / 2, y + sprite_height / 2, display_text);


var cursor_x = string_width(string_copy(text, 1, cursor_index - 1)) / 2;
var bar_width = string_width("|");
if (can_write && blink) {
	draw_text(x + sprite_width / 2 + cursor_x, y + sprite_height / 2, "|");
}
