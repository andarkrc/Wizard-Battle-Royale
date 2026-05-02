if (!enabled) exit;

draw_sprite_ext(sprite_index, hovered || selected, x, y, image_xscale, image_yscale, 0, c_white, 1);

var knob_width = sprite_get_width(sSliderKnob) * image_yscale;
var knob_pos = (slider_value - min_value) * (sprite_width - knob_width) / (max_value - min_value);
draw_sprite_ext(sSliderKnob, 0, x + knob_pos, y, image_yscale, image_yscale, 0, c_white, 1);

draw_setup(,,fa_right);
draw_text(x, y + sprite_height / 2, $"{min_value} ");
draw_setup(,,fa_left);
draw_text(x + sprite_width, y + sprite_height / 2, $" {max_value}");
draw_setup(,,, fa_bottom);
draw_text(x + sprite_width / 2, y, slider_value);