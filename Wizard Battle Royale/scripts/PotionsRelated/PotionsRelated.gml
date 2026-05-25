enum Potion {
	NONE,
	SPEED,
	INVISIBILITY,
	LIMITS,
	DASHING,
	BLINDING,
	FLAME,
	CLEANSING,
	LAST,
}

global.invisibility_duration = 20;
global.blinding_duration = 20;
global.flame_duration = 15;

/// @desc Returns the name of a potion.
/// @arg {Real} potion
function potion_get_name(potion) {
	var names = array_create(Potion.LAST);
	
	names[Potion.SPEED] = "Potion of Haste";
	names[Potion.INVISIBILITY] = "Potion of Invisibility";
	names[Potion.LIMITS] = "Potion of Limits";
	names[Potion.DASHING] = "Blessing of Clouds";
	names[Potion.BLINDING] = "Curse of Blinding";
	names[Potion.FLAME] = "Flame in a bottle";
	names[Potion.CLEANSING] = "Potion of Cleansing";
	
	return names[potion];
}