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

global.throwable_potions = [Potion.BLINDING, Potion.FLAME, Potion.REVERSE, Potion.BLINKING];

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