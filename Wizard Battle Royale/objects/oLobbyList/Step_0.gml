// Inherit the parent event
event_inherited();

with (oLobbyHandler) {
	if (lobbies != other.buttons) {
		other.buttons = lobbies;
	}	
}