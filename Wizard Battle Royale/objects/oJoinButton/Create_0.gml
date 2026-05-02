// Inherit the parent event
event_inherited();

text = "Join";

click_action = function() {
	global.connection_role = "guest";
	deactivate_menus();
	room_goto(rmTest);
}