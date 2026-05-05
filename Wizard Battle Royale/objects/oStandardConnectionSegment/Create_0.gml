// Inherit the parent event
event_inherited();

text = "Standard";

// this is the default selected one from the group :)
//selected = true;

click_action = function() {
	global.connection_type = "standard";
	
	with (oPublicToggle) {
		enabled = true;
	}
}