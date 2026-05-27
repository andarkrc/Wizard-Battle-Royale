// Inherit the parent event
event_inherited();

text = "Create";

click_action = function() {
	show_debug_message("I AM CREATING LOBBY NOW");
	global.connection_role = "host";
	deactivate_menus();
	room_goto(rmGame);
}

