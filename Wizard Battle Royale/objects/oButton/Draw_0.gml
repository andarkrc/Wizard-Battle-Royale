if (!enabled) exit;
draw_sprite_ext(sprite_index, hovered, x, y, image_xscale, image_yscale, 0, c_white, 1);
draw_setup();
draw_text(x + sprite_width / 2, y + sprite_height / 2, text);