// Inherit the parent event
event_inherited();

text = "Create Lobby";

click_action = function() {
	var active = !layer_get_visible("CreateLobbyMenu");
	deactivate_menus();
	layer_set_visible("MainMenu", true);
	layer_set_visible("CreateLobbyMenu", active);
	// Reset the menu
	global.connection_type = "standard";
	with (oLobbyNameField) {
		text = "";
	}
	with (oStandardConnectionSegment) {
		unselect_group_members();
		selected = true;
	}
	with (oPlayerCountSlider) {
		slider_value = 2;
	}
	with (oPublicToggle) {
		enabled = true;
		state = false;
	}
}