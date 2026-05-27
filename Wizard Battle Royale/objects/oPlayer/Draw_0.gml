if (damaged) {
	image_blend = c_red;
} else {
	image_blend = -1;
}

switch (state) {
	case State.JUMPING:
		sprite_index = sprite_jumping;
		break;
	
	case State.BREATHING:
		sprite_index = sprite_breathing;
		break;
	
	case State.RUNNING:
		sprite_index = sprite_running;
		break;
		
	case State.DASHING:
		sprite_index = sprite_dashing;
		break;
	
	case State.FALLING:
		sprite_index = sprite_falling;
		break;
	
	case State.SIDE_FALLING:
		sprite_index = sprite_side_falling;
		break;
	
	case State.IDLE:
	default:
		sprite_index = sprite_idle;
		break;
}

draw_setup();
draw_self();

draw_setup(c_white, image_alpha,,fa_bottom,fa_center);
draw_text(x, y - sprite_height / 2 - 20, name);

if (potion != Potion.NONE) {
	draw_sprite_ext(sPotions, potion, x, y, 1, 1, 0, c_white, image_alpha);
	
	if (array_contains(global.throwable_potions, potion) && mouse_check_button(mb_right) && id_ == oClientHandler.client_id) {
		var tx = mouse_x;
		var ty = mouse_y;
		var dx = tx - x;
		var dy = ty - y;
		var dy_math = -dy;
		
		var _g = 10 * 64;
		
		var d = point_distance(x, y, tx, ty);
		var v = 6 * 64 + (d / 600.0) * (12 * 64);
		if (v > 18 * 64) v = 18 * 64;
		
		var v_min_req = sqrt(_g * max(0, dy_math + d));
		if (v < v_min_req * 1.05) {
			v = v_min_req * 1.05;
		}
		
		var v2 = v * v;
		var v4 = v2 * v2;
		
		var root_term = v4 - _g * (_g * dx * dx + 2 * dy_math * v2);
		
		var vx = 0;
		var vy = 0;
		
		if (dx != 0 && root_term >= 0) {
			var root = sqrt(root_term);
			var angle_rad = arctan((v2 - root) / (_g * dx));
			if (dx < 0) angle_rad += pi;
			vx = v * cos(angle_rad);
			vy = -v * sin(angle_rad);
		} else {
			var dir = point_direction(x, y, tx, ty);
			vx = dcos(dir) * v;
			vy = -dsin(dir) * v;
		}
		
		var sim_x = x;
		var sim_y = y;
		var sim_vx = vx;
		var sim_vy = vy;
		
		var time_step = 1.0 / 120.0;
		var max_steps = 240; // 2 seconds of flight
		
		draw_set_color(c_white);
		draw_set_alpha(0.6);
		
		var prev_sim_x = sim_x;
		var prev_sim_y = sim_y;
		
		for (var i = 0; i < max_steps; i++) {
			sim_vy += _g * time_step;
			sim_x += sim_vx * time_step;
			sim_y += sim_vy * time_step;
			
			// Dashed line effect (draw 4 frames, skip 4 frames)
			if ((i div 4) % 2 == 0) { 
				draw_line_width(prev_sim_x, prev_sim_y, sim_x, sim_y, 3);
			}
			
			// Sweep collision check using exact sprite dimensions
			var w = sprite_get_width(sPotions) / 2;
			var h = sprite_get_height(sPotions) / 2;
			var min_x = min(prev_sim_x, sim_x) - w;
			var max_x = max(prev_sim_x, sim_x) + w;
			var min_y = min(prev_sim_y, sim_y) - h;
			var max_y = max(prev_sim_y, sim_y) + h;
			
			var hit_wall = collision_rectangle(min_x, min_y, max_x, max_y, oCollisionBox, false, true);
			
			var hit_top = false;
			if (sim_vy > 0) {
				hit_top = collision_rectangle(min_x, prev_sim_y + h, max_x, sim_y + h, oCollisionBoxTopOnly, false, true);
			} else {
				hit_top = collision_rectangle(min_x, sim_y + h, max_x, sim_y + h + 1, oCollisionBoxTopOnly, false, true);
			}
			
			var hit_player = collision_rectangle(min_x, min_y, max_x, max_y, oPlayer, false, true);
			if (hit_player != noone && hit_player.id_ == id_) {
				hit_player = noone; // Ignore self
			}
			
			if (hit_wall || hit_top || hit_player != noone) {
				// Beautiful impact marker: draw the actual potion transparently
				draw_sprite_ext(sPotions, potion, sim_x, sim_y, 1, 1, 0, c_white, 0.6);
				draw_set_color(c_red);
				draw_set_alpha(0.5);
				draw_circle(sim_x, sim_y, 2, false);
				draw_set_color(c_white);
				break;
			}
			
			prev_sim_x = sim_x;
			prev_sim_y = sim_y;
		}
		
		draw_set_alpha(1.0);
	}
}
