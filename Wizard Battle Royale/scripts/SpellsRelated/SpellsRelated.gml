enum Spell {
	NONE,
	FIREBALL,
	WIND_SLASH,
	SHIELD,
    ICE_SPIKE,
    LIGHTNING_BOLT,
	LAST,
}

global.spellcast_cooldown = 2;

function SpellSlot() constructor {
	type = Spell.NONE;
	casts_remaining = 1;
	cooldown = 0;
}

/// @desc Returns the number of casts a spell has.
/// @arg {Real} spell
function spell_get_max_casts(spell) {
	var casts = array_create(Spell.LAST);
	
	casts[Spell.FIREBALL] = 3;
	casts[Spell.WIND_SLASH] = 2;
	casts[Spell.SHIELD] = 1;
    casts[Spell.ICE_SPIKE] = 3;
    casts[Spell.LIGHTNING_BOLT] = 4;
	
	return casts[spell];
}

/// @desc Returns the daamge that a spell deals.
/// @arg {Real} spell
function spell_get_damage(spell) {
	var damage = array_create(Spell.LAST);

	// if a spell is not mentioned, it means it has damage = 0;	
	damage[Spell.FIREBALL] = 30;
	damage[Spell.WIND_SLASH] = 25;
    damage[Spell.ICE_SPIKE] = 20;
    damage[Spell.LIGHTNING_BOLT] = 15;

	return damage[spell];
}