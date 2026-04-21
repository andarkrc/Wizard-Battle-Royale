// Inherit the parent event
event_inherited();

width = 128;
height = 64;
ghost_text = "Player Name";

action = function() {
	global.player_name = (text != "") ? text : "Player";
}
