if (!broken) {
	image_index = potion;
	draw_self();
}

if (broken && potion == Potion.REVERSE) {
	draw_set_alpha(0.25);
	draw_set_colour(make_colour_rgb(80, 200, 255));
	draw_circle(x, y - 64, cloud_radius, false);
	
	draw_set_alpha(0.4);
	draw_set_colour(make_colour_rgb(150, 230, 255));
	draw_circle(x, y - 64, cloud_radius, true);
	
	draw_set_alpha(1);
	draw_set_colour(c_white);
}

if (focused && can_be_collected && !thrown) {
	draw_setup(,,fa_center, fa_bottom);
	draw_text(x, y - sprite_height * 2, "<E>");
	draw_text(x, y - sprite_height, potion_get_name(potion));
}