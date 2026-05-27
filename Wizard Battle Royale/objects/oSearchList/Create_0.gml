// Inherit the parent event
event_inherited();

text = "List";

selected = true;

click_action = function() {
	var reset = !layer_get_visible("JoinLobbyListMenu");
	deactivate_menus();
	layer_set_visible("MainMenu", true);
	layer_set_visible("JoinLobbyMenu", true);
	layer_set_visible("JoinLobbyListMenu", true);
	
	if (!reset) return;
		
	global.connection_type = "standard";
	
	global.lobby_code = "";
	
	with (oLobbyList) {
		scroll_offset = 0;
		button_filter = function(){
			return true;
		}
	} 
	
	with (oLobbyNameFilterTextField) {
		text = "";
	}
	
	with (oHideFullLobbiesToggle) {
		state = false;
	}
	
	with (oLobbyHandler) {
		request_new_lobbies();
	}
}
