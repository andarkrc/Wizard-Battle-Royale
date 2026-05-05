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
		sprite_index = sPlayerSideFalling;
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

