// Inherit the parent event
event_inherited();

ghost_text = ">Type to search lobbies<";

level = 0;

action = function() {
	with (oLobbyList) {
		lobby_name_filter = other.text;
		update_contents();
	}
}