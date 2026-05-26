// Inherit the parent event
event_inherited();

text = "Join Lobby";

click_action = function() {
	var active = !layer_get_visible("JoinLobbyMenu");
	deactivate_menus();
	layer_set_visible("MainMenu", true);
	layer_set_visible("JoinLobbyMenu", active);
	layer_set_visible("JoinLobbyListMenu", active);
		
	global.connection_type = "standard";
	
	global.lobby_code = "";
	
	with (oLobbyList) {
		scroll_offset = 0;
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