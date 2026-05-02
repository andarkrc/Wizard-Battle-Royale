// Inherit the parent event
event_inherited();

text = "Join Lobby";

click_action = function() {
	var active = !layer_get_visible("JoinLobbyMenu");
	deactivate_menus();
	layer_set_visible("MainMenu", true);
	layer_set_visible("JoinLobbyMenu", active);
	layer_set_visible("JoinLobbyDirectMenu", active);
	
	global.connection_type = "direct";
	
	with (oServerIPField) {
		text = "";
	}
}