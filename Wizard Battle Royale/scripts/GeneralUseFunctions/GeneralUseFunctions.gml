/// @desc Quick setup for drawing stuff.
/// @arg {Constant.Color} color
/// @arg {Real} alpha
/// @arg {Constant.HAlign} halign
/// @arg {Constant.VAlign} valign
/// @arg {Asset.GMFont} font
function draw_setup(color = c_white, alpha = 1, halign = fa_center, valign = fa_middle, font = fnArial12) {
	draw_set_colour(color);
	draw_set_alpha(alpha);
	draw_set_font(font);
	draw_set_halign(halign);
	draw_set_valign(valign);
}