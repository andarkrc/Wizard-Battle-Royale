// Inherit the parent event
event_inherited();

text = "Settings";

click_action = function() {
	var active = !layer_get_visible("SettingsMenu");
	deactivate_menus();
	layer_set_visible("MainMenu", true);
	layer_set_visible("SettingsMenu", active);
}
