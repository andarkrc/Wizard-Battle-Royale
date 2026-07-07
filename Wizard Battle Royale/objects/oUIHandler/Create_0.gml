should_stretch_view = false;

enum PopupType {
	ERROR,
	SONG,
	INFO
};

enum TransitionState {
    NONE,
    FADE_IN,
    HALF_POINT,
    FADE_OUT
};

transition_state = TransitionState.NONE;
transition_progress = 0;
transition_time = 1;
transition_speed = 1 / transition_time;
transition_points = [];
transition_function = function() {};
can_resume_transition = false;

active_popup = noone;

popup_queue = [];

add_popup = function(title, description = "", type = PopupType.ERROR) {
	array_push(popup_queue, {title : title, description: description, type: type});
}

activate_popup = function() {
	active_popup = instance_create_layer(window_get_width() - 10, 10, "PopupLayer", oPopupBox,
	{
		title: popup_queue[0].title,
		description: popup_queue[0].description
	});
	switch (popup_queue[0].type) {
		case PopupType.SONG:
			active_popup.title_color = c_green;
			break;
		
		case PopupType.INFO:
			active_popup.title_color = c_yellow;
			break;
		
		default:
		case PopupType.ERROR:
			active_popup.title_color = #DD2233;
			break;
	}
	array_shift(popup_queue);
}

activate_transition = function(transition_callback = function() {}) {
    if (transition_state != TransitionState.NONE) return;
    transition_state = TransitionState.FADE_IN;
    transition_progress = 0;
    transition_function = transition_callback;
    call_later(transition_time, time_source_units_seconds, function() {
        transition_state = TransitionState.FADE_OUT;
        transition_progress = 1;
        layer_set_visible("UILayerLoading", true);
        transition_function();
        layer_set_visible("UILayerLoading", false);
        call_later(transition_time, time_source_units_seconds, function() {
            transition_state = TransitionState.NONE;
        });
    });
}

activate_transition_half = function(transition_callback = function() {}) {
    if (transition_state != TransitionState.NONE) return;
    can_resume_transition = false;
    transition_state = TransitionState.FADE_IN;
    transition_progress = 0;
    transition_function = transition_callback;
    call_later(transition_time, time_source_units_seconds, function() {
        transition_state = TransitionState.HALF_POINT;
        transition_progress = 1;
        layer_set_visible("UILayerLoading", true);
        transition_function();
    });
}

activate_transition_half_end = function() {
    transition_state = TransitionState.FADE_OUT;
    layer_set_visible("UILayerLoading", false);
    call_later(transition_time, time_source_units_seconds, function() {
        transition_state = TransitionState.NONE; 
    });
}

resume_transition = function() {
    can_resume_transition = true;
}

repeat (15) {
    array_push(transition_points, 
    {
        x: random(1), 
        y: random(1),
        scale: random_range(0.25, 1)
    });
}