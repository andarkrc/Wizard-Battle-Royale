// Inherit the parent event
event_inherited();

text = "Refresh";

level = 0;

click_action = function()
{
	global.lobby_code = "";
	with (oLobbyHandler) {
		request_new_lobbies();
	}
}