draw_sprite_ext(sprite_index, 0, x + offset * sprite_width, y, image_xscale, image_yscale, 0, c_white, 1);

draw_setup(title_color, 1, fa_left, fa_top);
draw_text(x + margin - sprite_width + offset * sprite_width, y + margin, title);


draw_setup(description_color, 1, fa_left, fa_top);
draw_text(x + margin - sprite_width + offset * sprite_width, y + string_height(title) + margin, processed_description);
