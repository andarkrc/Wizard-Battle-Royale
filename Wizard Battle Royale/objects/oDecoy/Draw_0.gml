switch (state) {
	case State.JUMPING:
		sprite_index = sPlayerJumpingRed;
		break;
	
	case State.BREATHING:
		sprite_index = sPlayerBreathingRed;
		break;
	
	case State.RUNNING:
		sprite_index = sPlayerRunningRed;
		break;
		
	case State.DASHING:
		sprite_index = sPlayerSideFallingRed;
		break;
	
	case State.FALLING:
		sprite_index = sPlayerFallingRed;
		break;
	
	case State.SIDE_FALLING:
		sprite_index = sPlayerSideFallingRed;
		break;
	
	case State.IDLE:
	default:
		sprite_index = sPlayerIdleRed;
		break;
}

draw_setup();
draw_self();

draw_setup(c_white, image_alpha,,fa_bottom,fa_center);
draw_text(x, y - sprite_height / 2 - 20, source_name);
