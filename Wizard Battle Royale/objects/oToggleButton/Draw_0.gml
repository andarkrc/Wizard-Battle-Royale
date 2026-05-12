if (!enabled) exit;

draw_sprite_ext(sprite_index, 2 * state + hovered, x, y, image_xscale, image_yscale, 0 , c_white, 1);

if (text != "") {
    var center = (sprite_width + sprite_get_width(sprite_index) / 2 - 2) / 2;
	draw_setup(,,fa_center, fa_middle);
	draw_text(x + center, y + sprite_height / 2, $" {text}");	
}