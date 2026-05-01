// Inherit the parent event
event_inherited();

ghost_text = "Player Name";

action = function() {
	global.player_name = (text != "") ? text : "Player";
}
