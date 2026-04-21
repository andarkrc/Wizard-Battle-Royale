// Inherit the parent event
event_inherited();

text = "Create Lobby";

width = 128;
height = 64;

click_action = function() {
	global.connection_type = "direct-host";
	room_goto(rmTest);
}