draw_setup(,,fa_left, fa_top);
if (global.connection_role == "host" && global.connection_type == "standard") {
	draw_text(16, 16, $"Lobby code: {global.lobby_code}");
}