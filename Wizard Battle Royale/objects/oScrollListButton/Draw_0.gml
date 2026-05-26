if (!enabled) exit;
draw_sprite_ext(sprite_index, hovered, x, y, image_xscale, image_yscale, 0, c_white, 1);
draw_setup(,, fa_left, fa_middle);
draw_text(x, y + sprite_height / 2, $" {text}");
draw_setup(,, fa_right, fa_middle);
draw_text(x + sprite_width, y + sprite_height / 2, $"{text_right} ");
