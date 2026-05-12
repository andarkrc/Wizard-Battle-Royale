if (state == GameState.GAME) {
	var my_player = player_refs[? oClientHandler.client_id];
	
	var camera = view_get_camera(0);
	var cw = camera_get_view_width(camera);
	var ch = camera_get_view_height(camera);
	camera_set_view_pos(camera, my_player.x - cw / 2, my_player.y - ch / 2);
}