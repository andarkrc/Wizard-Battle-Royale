if (damaged) {
	image_blend = c_red;
} else {
	image_blend = -1;
}

draw_self();

switch (state) {
	case State.JUMPING:
		sprite_index = sPlayerJumping;
		break;
	
	case State.BREATHING:
		sprite_index = sPlayerBreathing;
		break;
	
	case State.RUNNING:
		sprite_index = sPlayerRunning;
		break;
		
	case State.DASHING:
		sprite_index = sPlayerRunning;
		break;
	
	case State.FALLING:
		sprite_index = sPlayerFalling;
		break;
	
	case State.SIDE_FALLING:
		sprite_index = sPlayerSideFalling;
		break;
	
	case State.IDLE:
	default:
		sprite_index = sPlayerIdle;
		break;
}

draw_setup(c_white,,,fa_bottom,fa_center);
draw_text(x, y - sprite_height / 2 - 20, name);

/* Dash Error Message */
if (dash_error_msg_timer > 0) {
	draw_set_color(c_red);
	draw_text(x, y - sprite_height / 2 - 40, "Dash not ready");
	draw_set_color(c_white);
}

/* Dash Charges UI */
var ui_y = y - sprite_height / 2 - 10;
var ui_w = 20;
var ui_spacing = 5;
var start_x = x - ((ui_w * dash_max_charges) + (ui_spacing * (dash_max_charges - 1))) / 2;

for (var i = 0; i < dash_max_charges; i++) {
	var cur_x = start_x + i * (ui_w + ui_spacing);
	
	/* Draw outline */
	draw_rectangle(cur_x, ui_y - 4, cur_x + ui_w, ui_y, true);
	
	if (i < dash_charges) {
		/* Full charge */
		draw_rectangle(cur_x, ui_y - 4, cur_x + ui_w, ui_y, false);
	} else if (i == dash_charges && time_source_get_state(ts_dash_recharge) == time_source_state_active) {
		/* Recharging charge */
		var remaining = time_source_get_time_remaining(ts_dash_recharge);
		var total = dash_cooldown_seconds;
		var pct = 1.0 - (remaining / total);
		if (pct > 0) {
			draw_rectangle(cur_x, ui_y - 4, cur_x + (ui_w * pct), ui_y, false);
		}
	}
}