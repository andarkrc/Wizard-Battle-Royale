// Inherit the parent event
event_inherited();

text = "Create";

click_action = function() {
	global.connection_role = "host";
	deactivate_menus();
	room_goto(rmGame);
}
