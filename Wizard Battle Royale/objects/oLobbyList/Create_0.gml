// Inherit the parent event
event_inherited();

button_asset_type = oLobbyListButton;

lobby_name_filter = "";
hide_full_lobbies = false;

button_filter = function(button, idx)
{
	if (hide_full_lobbies) {
		if (button.data.players >= button.data.max_players) {
			return false;
		}
	}
	if (lobby_name_filter != "") {
		if (!string_starts_with(button.text, lobby_name_filter)) {
			return false;
		}
	}
	return true;
}