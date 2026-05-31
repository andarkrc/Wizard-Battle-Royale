var ww = window_get_width();
var wh = window_get_height();
var sw = sprite_get_width(sprite_index);
var sh = sprite_get_height(sprite_index);

x = ww - 10;
y = 10;

image_xscale = window_fraction_x * ww / sw;
process_description();
image_yscale = max(window_fraction_y * wh, string_height(processed_description) + margin * 2) / sh;