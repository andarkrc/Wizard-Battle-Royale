enum Spell {
	NONE,
	FIREBALL,
	WIND_SLASH,
	SHIELD
}

function SpellSlot() constructor {
	type = Spell.NONE;
	casts_remaining = 1;
	cooldown = 0;
}