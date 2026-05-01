// Inherit the parent event
event_inherited();

text = "Create Lobby";

click_action = function() {
	var active = !layer_get_visible("CreateLobbyMenu");
	deactivate_menus();
	layer_set_visible("MainMenu", true);
	layer_set_visible("CreateLobbyMenu", active);
}