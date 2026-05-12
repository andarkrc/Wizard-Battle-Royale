image_index = potion;
draw_self();

if (focused && can_be_collected) {
	draw_setup(,,fa_center, fa_bottom);
	draw_text(x, y - sprite_height, "<E>");
}