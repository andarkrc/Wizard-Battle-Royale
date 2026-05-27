enum Potion {
	NONE,
	SPEED,
	INVISIBILITY,
	LIMITS,
	DASHING,
	BLINDING,
	FLAME,
	CLEANSING,
	TEN_HP,
	HEAL_HALF,
	DECOY,
	REVERSE,
	BLINKING,
	DEVIL,
	LAST,
}

global.invisibility_duration = 20;

global.blinding_duration = 20;
global.flame_duration = 15;
global.decoy_duration = 10;
global.reverse_duration = 15;
global.blinking_duration = 15;

global.blinding_effect_duration = 20;
global.reverse_effect_duration = 10;
global.blinking_effect_duration = 20;

global.throwable_potions = [
	Potion.BLINDING, Potion.FLAME, Potion.REVERSE, Potion.BLINKING,
	Potion.SPEED, Potion.INVISIBILITY, Potion.LIMITS, Potion.DASHING,
	Potion.CLEANSING, Potion.TEN_HP, Potion.HEAL_HALF, Potion.DECOY,
	Potion.DEVIL
];

/// @desc Returns the name of a potion.
/// @arg {Real} potion
function potion_get_name(potion) {
	var names = array_create(Potion.LAST);
	
	names[Potion.SPEED] = "Potion of Haste";
	names[Potion.INVISIBILITY] = "Potion of Invisibility";
	names[Potion.LIMITS] = "Potion of Limits";
	names[Potion.DASHING] = "Blessing of Clouds";
	names[Potion.BLINDING] = "Curse of Blinding";
	names[Potion.FLAME] = "Flame in a Bottle";
	names[Potion.CLEANSING] = "Potion of Cleansing";
	names[Potion.TEN_HP] = "Potion of 10 HP";
	names[Potion.HEAL_HALF] = "Potion of Healing Half";
	names[Potion.DECOY] = "Decoy";
	names[Potion.REVERSE] = "Curse of Reverse";
	names[Potion.BLINKING] = "Curse of Blinking";
	names[Potion.DEVIL] = "Devil Pact";
	
	return names[potion];
}

/// @desc Returns [color1, color2, color3] for particle effects based on potion type.
/// @arg {Real} pot_type
/// @return {Array<Real|Constant.Color>} description
function potion_get_particle_colors (pot_type) {
	switch (pot_type) {
		case Potion.SPEED:
			return [make_colour_rgb(0, 200, 255), make_colour_rgb(0, 120, 200), make_colour_rgb(0, 40, 80)];
		case Potion.INVISIBILITY:
			return [make_colour_rgb(200, 255, 100), make_colour_rgb(150, 200, 50), make_colour_rgb(100, 150, 20)]; // verde-galbui
		case Potion.LIMITS:
			return [make_colour_rgb(230, 180, 255), make_colour_rgb(200, 130, 255), make_colour_rgb(150, 80, 200)]; // mov deschis
		case Potion.DASHING:
			return [make_colour_rgb(50, 255, 50), make_colour_rgb(20, 200, 20), make_colour_rgb(0, 100, 0)]; // verde mai verzui
		case Potion.CLEANSING:
			return [make_colour_rgb(255, 180, 200), make_colour_rgb(255, 130, 170), make_colour_rgb(200, 80, 120)]; // roz deschis
		case Potion.TEN_HP:
			return [make_colour_rgb(255, 255, 150), make_colour_rgb(255, 220, 100), make_colour_rgb(200, 180, 50)]; // galben deschis
		case Potion.HEAL_HALF:
			return [make_colour_rgb(0, 50, 150), make_colour_rgb(0, 30, 100), make_colour_rgb(0, 10, 50)]; // albastru inchis
		case Potion.DECOY:
			return [make_colour_rgb(255, 100, 255), make_colour_rgb(200, 50, 200), make_colour_rgb(150, 0, 150)]; // roz mov
		case Potion.DEVIL:
			return [c_red, c_lime, c_blue]; // curcubeu
		default:
			return [c_white, c_ltgray, c_dkgray];
	}
}