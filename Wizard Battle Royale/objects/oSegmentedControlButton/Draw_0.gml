var subimage = 0;
if (hovered) subimage = 1;
if (selected) subimage = 2;
draw_sprite_ext(sprite_index, subimage, x, y, image_xscale, image_yscale, 0, c_white, 1);


if (text != "")
{
	draw_setup(c_white, 1, fa_center, fa_middle, font);
	draw_text(x + sprite_width / 2, y + sprite_height / 2, text);
}