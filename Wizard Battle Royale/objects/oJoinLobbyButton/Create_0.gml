// Inherit the parent event
event_inherited();

text = "Join Lobby";

width = 128;
height = 64;

click_action = function() {
	global.connection_type = "direct-client";
	room_goto(rmTest);
}