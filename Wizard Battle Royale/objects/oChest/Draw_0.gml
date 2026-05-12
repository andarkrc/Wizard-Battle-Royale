if (potion == Potion.NONE) {
	sprite_index = sChestOpened;
} else {
	sprite_index = sChest;
}

draw_self();

if (focused && potion != Potion.NONE && can_be_collected) {
	draw_setup(,,fa_center, fa_bottom);
	var yy = sprite_height;
	draw_text(x + sprite_width / 2, y, "<E>");
}