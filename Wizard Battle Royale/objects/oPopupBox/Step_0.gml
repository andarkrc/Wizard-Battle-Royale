var _dt = delta_time / 1000000;

if (state == PopupBoxState.SLIDE_IN) {
	offset -= _dt * slide_speed;
	if (offset <= 0) {
		offset = 0;
		state = PopupBoxState.IDLE;
		call_later(display_time, time_source_units_seconds,
			function() {
				state = PopupBoxState.SLIDE_OUT;
			}
		);
	}
}

if (state == PopupBoxState.SLIDE_OUT) {
	offset += _dt * slide_speed;
	if (offset >= 1.1) {
		instance_destroy();
	}
}