/// @desc Quick setup for drawing stuff.
/// @arg {Constant.Color} color
/// @arg {Real} alpha
/// @arg {Constant.HAlign} halign
/// @arg {Constant.VAlign} valign
/// @arg {Asset.GMFont} font
function draw_setup(color = c_white, alpha = 1, halign = fa_center, valign = fa_middle, font = global.default_font) {
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

/// @desc Deactivates every ui layer
function deactivate_menus() {
	layer_set_visible("MainMenu", false);
	layer_set_visible("CreateLobbyMenu", false);
	layer_set_visible("JoinLobbyMenu", false);
	layer_set_visible("JoinLobbyDirectMenu", false);
	layer_set_visible("JoinLobbyCodeMenu", false);
	layer_set_visible("JoinLobbyListMenu", false);
	layer_set_visible("SettingsMenu", false);
}

/// @desc Sets the number of spells slots a player has to a new value.
/// @arg {Array<SpellSlot>} slots
function resize_spell_slots(slots, new_size) {
	if (new_size < array_length(slots)) {
		array_resize(slots, new_size);
	} else  while (new_size > array_length(slots)) {
		array_push(slots, new SpellSlot());	
	}
}

/// @desc Returns the intersection point between the ray and the object.
/// @arg {Real} x
/// @arg {Real} y
/// @arg {Real} dir
/// @arg {Real} max_dist
/// @arg {Asset.GMObject} object
/// @return {Struct}
function ray_cast_hit_point(x, y, dir, max_dist, object) {
	var left = 0;
	var right = max_dist;
	
	var lx = lengthdir_x(max_dist, dir);
	var ly = lengthdir_y(max_dist, dir);
	var p = {x: x + lx, y: y + ly};
	
	if (collision_line(x, y, x + lx, y + ly, object, false, true) == noone) {
		return p;
	}
	var middle;
	while (left < right) {
		middle = (left + right) / 2;
		
		var xx = lengthdir_x(middle, dir);
		var yy = lengthdir_y(middle, dir);
		
		if (collision_line(x, y, x + xx, y + yy, object, false, false) != noone) {
			right = middle - 1;
			p.x = x + xx;
			p.y = y + yy;
			continue;
		} else {
			left = middle + 1;
			continue;
		}
		
	}
	
	return p;
}