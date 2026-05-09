enum Spell {
	NONE,
	FIREBALL,
	WIND_SLASH,
	SHIELD,
	LAST_SPELL,
}

function SpellSlot() constructor {
	type = Spell.NONE;
	casts_remaining = 1;
	cooldown = 0;
}

/// @desc Returns the number of casts a spell has.
/// @arg {Real} spell
function spell_get_max_casts(spell) {
	var casts = array_create(Spell.LAST_SPELL);
	
	casts[Spell.NONE] = 0;
	casts[Spell.FIREBALL] = 3;
	casts[Spell.WIND_SLASH] = 2;
	casts[Spell.SHIELD] = 1;
	
	return casts[spell]
} 