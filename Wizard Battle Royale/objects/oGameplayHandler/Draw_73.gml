if (state == GameState.GAME && global.ray_tracing) {
	// localized shadows
	var cam = view_get_camera(0);
	var xx = camera_get_view_x(cam);
	var yy = camera_get_view_y(cam);
	var w = camera_get_view_width(cam);
	var h = camera_get_view_height(cam);
	
	if (!surface_exists(global.shadow_surface)) {
		global.shadow_surface = surface_create(w, h);
		show_debug_message($"NEW SURFACE DIMS: {w} {h}");
	}
	var surface = global.shadow_surface;
	surface_set_target(surface);
	draw_clear_alpha(c_black, 0.5);
	
	var mx = xx + w / 2;
	var my = yy + h / 2;
	
	var ray_step = 1;
	var ray_length = max(w, h);
	
	var points = [];
	
	var steps = 360 / ray_step;
	
	for (var i = 0; i <= steps; i++) {
		var angle = i * ray_step;
		var lx = lengthdir_x(ray_length, angle);
		var ly = lengthdir_y(ray_length, angle);
		
		var p = ray_cast_hit_point(mx, my, angle, ray_length, oCollisionBox);
		array_push(points, p);
	}
	
	gpu_set_blendmode(bm_subtract);
	draw_setup(c_black, 1);
	
	draw_primitive_begin(pr_trianglefan);
	
	draw_vertex(mx - xx, my - yy);
	
	for (var i = 0; i < array_length(points); i++) {
		draw_vertex(points[i].x - xx, points[i].y - yy);
	}

	draw_vertex(points[0].x - xx, points[0].y - yy);
	
	draw_primitive_end();
	
	surface_reset_target();
	gpu_set_blendmode(bm_normal);
	
	draw_setup();
	draw_surface(surface, xx, yy);
}


if (ds_map_exists(player_refs, oClientHandler.client_id)) {
	var my_player = player_refs[? oClientHandler.client_id];
	
	// Curse of Blinding overlay
	if (state == GameState.GAME && instance_exists(my_player) && my_player.blinded) {
		var _dt = delta_time / 1000000;
		my_player.blind_time -= _dt;
		
		if (my_player.blind_time > 10.0) {
			my_player.blind_opacity = 1.0;
		} else {
			my_player.blind_opacity = my_player.blind_time / 10.0;
		}
		
		if (my_player.blind_opacity < 0) {
			my_player.blind_opacity = 0;
		}
		
		if (my_player.blind_opacity > 0) {
			var cam = view_get_camera(0);
			var xx = camera_get_view_x(cam);
			var yy = camera_get_view_y(cam);
			var w = camera_get_view_width(cam);
			var h = camera_get_view_height(cam);
			
			if (!surface_exists(global.shadow_surface)) {
				global.shadow_surface = surface_create(w, h);
			}
			
			var surface = global.shadow_surface;
			
			surface_set_target(surface);
			draw_clear_alpha(c_black, my_player.blind_opacity * 0.95);
			
			var px = my_player.x - xx;
			var py = my_player.y - sprite_get_height(sPlayerIdleRed) / 2 - yy;
			var blind_radius = 200;
			
			gpu_set_blendmode(bm_subtract);
			draw_set_color(c_white);
			for (var i = 10; i > 0; i--) {
				draw_set_alpha((10-i)/10);
				draw_circle(px, py, i / 10 * blind_radius, false);
			}
			
			gpu_set_blendmode(bm_normal);
			surface_reset_target();
			
			draw_set_color(c_white);
			draw_set_alpha(1.0);
			draw_surface(surface, xx, yy);
		}
	}
	
	// Evil Eye blink overlay
	if ((state == GameState.LOBBY || state == GameState.GAME) && instance_exists(my_player) && my_player.blinking) {
		if (current_time % 2000 < 350) {
			var cam = view_get_camera(0);
			var xx = camera_get_view_x(cam);
			var yy = camera_get_view_y(cam);
			var w = camera_get_view_width(cam);
			var h = camera_get_view_height(cam);
			
			draw_set_alpha(0.95);
			draw_set_colour(c_black);
			draw_rectangle(xx, yy, xx + w, yy + h, false);
			draw_set_alpha(1);
			draw_set_colour(c_white);
		}
	}
}