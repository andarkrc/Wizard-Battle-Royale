// Inherit the parent event
event_inherited();

ghost_text = ">Type to change Player name<";

action = function() {
	global.player_name = (text != "") ? text : "Player";
}
