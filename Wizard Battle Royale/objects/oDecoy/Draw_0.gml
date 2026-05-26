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

draw_setup();
draw_self();

draw_setup(c_white, image_alpha,,fa_bottom,fa_center);
draw_text(x, y - sprite_height / 2 - 20, source_name);
