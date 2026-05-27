// Inherit the parent event
event_inherited();

min_value = 0;
max_value = 100;
step_value = 1;


update_action = function() {
	global.sound_volume = slider_value / 100;
	audio_group_set_gain(audiogroup_default, global.sound_volume);
}

slider_value = global.sound_volume * 100;