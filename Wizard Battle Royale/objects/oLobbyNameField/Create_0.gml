// Inherit the parent event
event_inherited();

ghost_text = "Lobby name"

action = function() {
	if (text != "") {
		global.lobby_name = text;
	} else {
		global.lobby_name = $"{global.player_name}'s Lobby";
	}
}