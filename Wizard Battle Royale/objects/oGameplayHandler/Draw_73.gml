if (state == GameState.GAME && 0) {
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