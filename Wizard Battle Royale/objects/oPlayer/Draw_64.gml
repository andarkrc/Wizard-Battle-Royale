if (combat_active && id_ == oClientHandler.client_id) {
	var spell_slot_scale = 1.5;
	var spell_slot_size = sprite_get_width(sSpellSlot) * spell_slot_scale;
	var spacing = 8;
	var startx = spell_slot_size * 2;
	var spell_slots_y = display_get_gui_height() - 3 * spacing - spell_slot_size / 2;
	
	for (var i = 0; i < array_length(spells); i++) {
		var xx = startx + (spacing + spell_slot_size) * i;
		var yy = spell_slots_y;
		draw_sprite_ext(sSpellSlot, spells[i].type, xx, yy, spell_slot_scale, spell_slot_scale, 0, c_white, 1);
		if (i == selected_spell) {
			draw_sprite_ext(sSpellSlotHighlight, 0, xx , yy, spell_slot_scale, spell_slot_scale, 0, c_white, 1);
		}
		draw_setup(,,fa_left, fa_bottom);
		draw_text(startx + (spacing + spell_slot_size) * i, yy, $" {i + 1}");
		if (spells[i].cooldown > 0) {
			draw_setup(c_gray, 0.5);
			draw_rectangle(xx, yy, xx + spell_slot_size, yy - spell_slot_size * spells[i].cooldown / global.spellcast_cooldown, false);
		}
	}
	
	var endx = startx + spacing * (max_spell_count - 1) + spell_slot_size * max_spell_count;
	
	var healthbar_y1 = spell_slots_y + spacing;
	var healthbar_y2 = healthbar_y1 + spell_slot_size / 2;
	
	draw_setup();
	draw_healthbar(startx, healthbar_y1, endx, healthbar_y2, hp, c_black, c_red, c_red, 0, true, false);
	draw_setup(,, fa_left, fa_middle);
	draw_text(startx, (healthbar_y1 + healthbar_y2) / 2, $" {hp}");
	draw_setup(,,fa_right, fa_middle);
	draw_text(startx, spell_slots_y - spell_slot_size / 2, "Spells    ");
	draw_text(startx, (healthbar_y1 + healthbar_y2) / 2, "HP    ");
	
	draw_setup(,,fa_left);
	draw_text(8, 64, $"x: {x}, y: {y}");
}