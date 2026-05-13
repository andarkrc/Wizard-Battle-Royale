if (state == GameState.GAME) {
	var my_player = player_refs[? oClientHandler.client_id];
	
	var camera = view_get_camera(0);
	var cw = camera_get_view_width(camera);
	var ch = camera_get_view_height(camera);
	camera_set_view_pos(camera, my_player.x - cw / 2, my_player.y - ch / 2);
}

if (keyboard_check_pressed(ord("L"))) {
	var layers = layer_get_all();
	for (var i = 0; i < array_length(layers); i++) {
		show_debug_message($"{layer_get_name(layers[i])}");
	}
}