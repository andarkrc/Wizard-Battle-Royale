draw_sprite_ext(sprite_index, selected, x, y, width / sprite_width, height / sprite_height, 0, c_white, 1);

if (text != "")
{
	draw_setup(c_white, 1, fa_center, fa_middle, font);
	draw_text(x + width / 2, y + height / 2, text);
}
