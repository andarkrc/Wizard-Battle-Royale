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
	names[Potion.TEN_HP] = "Potion of 10 HP";
	names[Potion.HEAL_HALF] = "Potion of healing half";
	
	return names[potion];
}