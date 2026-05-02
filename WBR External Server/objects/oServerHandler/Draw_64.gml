draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
for (var i = 0; i < array_length(lobbies); i++) {
	draw_text(16, 16 + 16 * i, 
	$"Name \"{lobbies[i].name}\": Code: {lobbies[i].code}, Host: {lobbies[i].host},{lobbies[i].players}");
}

draw_set_halign(fa_right);
draw_text(display_get_gui_width() - 16, 16, $"Port: {port}");