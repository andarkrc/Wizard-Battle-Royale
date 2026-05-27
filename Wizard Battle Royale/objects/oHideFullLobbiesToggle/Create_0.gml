// Inherit the parent event
event_inherited();

level = 0;

click_action = function() {
	with (oLobbyList) {
		hide_full_lobbies = other.state;
		update_contents();
	}
}