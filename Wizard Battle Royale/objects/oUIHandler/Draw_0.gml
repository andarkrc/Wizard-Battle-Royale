var _dt = delta_time / 1_000_000;
var shape_scale = min(window_get_width(), window_get_height());

if (transition_state == TransitionState.FADE_IN) {
    transition_progress += _dt * transition_speed;
}

if (transition_state == TransitionState.FADE_OUT) {
    transition_progress -= _dt * transition_speed;
    //transition_progress = clamp(transition_progress, 0, 1);
}

if (transition_state == TransitionState.FADE_IN ||
    transition_state == TransitionState.FADE_OUT ||
    transition_state == TransitionState.HALF_POINT) {
    
    draw_setup(c_black);
    for (var i = 0; i < array_length(transition_points); i++) {
        draw_circle_color(transition_points[i].x * window_get_width(), transition_points[i].y * window_get_height(), 
            transition_progress * transition_points[i].scale * shape_scale,
            #000000, #0F0F0F, false); 
    }
}