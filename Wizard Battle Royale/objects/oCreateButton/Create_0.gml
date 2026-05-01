// Inherit the parent event
event_inherited();

text = "Create";

click_action = function() {
	deactivate_menus();
	global.connection_type = "direct-host";	
	room_goto(rmTest);
}

