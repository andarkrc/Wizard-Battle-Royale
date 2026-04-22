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

/// @desc Get the type of a particle from a Particle System Asset
/// @arg {Asset.GMParticleSystem} asset
/// @arg {Real} emmiter_index
function particle_get_type(asset, emitter_index = 0) {
	return particle_get_info(asset).emitters[emitter_index].parttype.ind;
}