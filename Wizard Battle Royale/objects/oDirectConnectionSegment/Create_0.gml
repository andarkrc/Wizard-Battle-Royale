// Inherit the parent event
event_inherited();

text = "Direct";
selected = true;
click_action = function() {
	global.connection_type = "direct";
	
	with (oPublicToggle) {
		enabled = false;
	}
}