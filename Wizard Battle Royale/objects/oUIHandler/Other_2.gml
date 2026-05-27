deactivate_menus();
layer_set_visible("MainMenu", true);

randomize();

audio_group_set_gain(audiogroup_default, global.sound_volume);
//audio_listener_orientation(0, 0, 0, 0, 1, 0);