// Inherit the parent event
event_inherited();

ghost_text = "<IP>:<Port>";

width = 128;
height = 64;

action = function() {
	var tokens = string_split(text, ":");
	if (array_length(tokens) != 2) return;
	global.server_ip = tokens[0];
	global.server_port = real(tokens[1]);
}
