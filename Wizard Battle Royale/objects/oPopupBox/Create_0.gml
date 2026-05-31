event_inherited();
// title = "";       <- from variable definition
// description = ""; <-

level = 100;

processed_description = "";

title_color = c_white;

description_color = c_ltgray;

offset = 1.1;

slide_speed = 2;

display_time = 5;

margin = 10;
window_fraction_x = 0.2;
window_fraction_y = 0.1;

enum PopupBoxState {
	SLIDE_IN,
	SLIDE_OUT,
	IDLE,
};

state = PopupBoxState.SLIDE_IN;

process_description = function() {
	processed_description = "";
	var toks = string_split(description, " ");
	var line = "";
	for (var i = 0; i < array_length(toks); i++) {
		if (string_width(line + toks[i]) > sprite_width - margin * 2) {
			if (processed_description == "") {
				processed_description = line;
			} else {
				processed_description += "\n" + line;
			}
			line = toks[i];
		} else {
			line += toks[i];
		}
		if (i != array_length(toks) - 1) {
			line += " ";
		}
	}
	if (processed_description == "") {
		processed_description = line;
	} else {
		processed_description += "\n" + line;
	}
}

var ww = window_get_width();
var wh = window_get_height();
var sw = sprite_get_width(sprite_index);
var sh = sprite_get_height(sprite_index);

image_xscale = window_fraction_x * ww / sw;
process_description();
image_yscale = max(window_fraction_y * wh, string_height(title) + string_height(processed_description) + margin * 3) / sh;