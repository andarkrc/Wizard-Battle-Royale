// Inherit the parent event
event_inherited();

text = "Direct";

click_action = function() {
	global.connection_type = "direct";
	
	with (oPublicToggle) {
		enabled = false;
	}
}