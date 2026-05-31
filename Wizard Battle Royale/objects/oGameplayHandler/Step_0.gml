if (state == GameState.GAME) {
	if (ds_map_exists(player_refs, oClientHandler.client_id)) {
		followed_player = player_refs[? oClientHandler.client_id];
	}
	else if (free_cam == false) {
		var all_players = ds_map_keys_to_array(player_refs);
		if (array_length(all_players) != 0) {
			followed_player = player_refs[? all_players[0]];
			followed_player_idx = 0;
			free_cam = true;
		}
	}
	
	if (free_cam) {
		var next_player = keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"));
		if (next_player != 0) {
			var all_players = ds_map_keys_to_array(player_refs);
			if (array_length(all_players) != 0) {
				followed_player_idx = modulo(followed_player_idx + next_player, array_length(all_players));
				followed_player = player_refs[? all_players[followed_player_idx]];
			}
		}
	}
	
	if (instance_exists(followed_player)) {
		var camera = view_get_camera(0);
		var cw = camera_get_view_width(camera);
		var ch = camera_get_view_height(camera);
		camera_set_view_pos(camera, followed_player.x - cw / 2, followed_player.y - ch / 2);
	}
}

if (state == GameState.GAME) {
	var camera = view_get_camera(0);
	var cw = camera_get_view_width(camera);
	var ch = camera_get_view_height(camera);
	audio_listener_position(camera_get_view_x(camera) + cw / 2, camera_get_view_y(camera) + ch / 2, 0);
}

if (state == GameState.LOBBY) {
	with (oPlayer) {
		if (id_ == oClientHandler.client_id) {
			audio_listener_position(x, y, 0);
		}
	}
}

if (keyboard_check_pressed(ord("L"))) {
	var layers = layer_get_all();
	for (var i = 0; i < array_length(layers); i++) {
		show_debug_message($"{layer_get_name(layers[i])}");
	}
}