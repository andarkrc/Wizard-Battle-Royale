if (window_has_focus()) {
	var w = window_get_width();
	var h = window_get_height();
	
	if (w > 0 && h > 0) {
		if (display_get_gui_width() != w || display_get_gui_height() != h) {
			camera_set_view_size(view_camera[0], w, h);
			view_wport[0] = w;
			view_hport[0] = h;
			
			surface_resize(application_surface, w, h);
			display_set_gui_size(w, h);
			
			var d = flexpanel_direction.LTR;
			flexpanel_calculate_layout(layer_get_flexpanel_node("MainMenu"), w, h, d);
			flexpanel_calculate_layout(layer_get_flexpanel_node("CreateLobbyMenu"), w, h, d);
			flexpanel_calculate_layout(layer_get_flexpanel_node("JoinLobbyMenu"), w, h, d);
			flexpanel_calculate_layout(layer_get_flexpanel_node("SettingsMenu"), w, h, d);
		}
	}
}