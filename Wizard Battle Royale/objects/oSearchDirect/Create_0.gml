// Inherit the parent event
event_inherited();

text = "Direct";

selected = true;

click_action = function() {
	deactivate_menus();
	layer_set_visible("MainMenu", true);
	layer_set_visible("JoinLobbyMenu", true);
	layer_set_visible("JoinLobbyDirectMenu", true);
}