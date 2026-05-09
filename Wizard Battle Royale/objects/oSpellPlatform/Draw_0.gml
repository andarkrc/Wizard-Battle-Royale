draw_self();

draw_sprite_ext(sSpellScroll, spell, x + sprite_width / 2, y - sprite_height, image_xscale, image_yscale, 0, c_white, 1);

if (focused && spell != Spell.NONE) {
	draw_setup(,, fa_center, fa_bottom);
	var yy = sprite_get_height(sSpellScroll) * image_yscale + sprite_height;
	draw_text(x + sprite_width / 2, y - yy, "<E>");
}