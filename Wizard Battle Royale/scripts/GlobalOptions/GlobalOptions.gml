// GENERAL USE MACROS

#macro METER 64

// system
global.default_font = fnPixelPurl;
global.fallof_ref = 1 * METER;
global.fallof_max = 10 * METER;
global.fallof_model = audio_falloff_exponent_distance_clamped;

// connection settings
global.server_ip = "127.0.0.1";
global.server_port = 6000;
global.connection_type = "direct";
global.connection_role = "";

global.external_server_ip = "0.tcp.ngrok.io";
global.external_server_port = 15839;

global.external_server_port_udp = 15839;

// lobby settings
global.lobby_name = "";
global.lobby_is_public = false;
global.lobby_max_player_count = 2;

global.lobby_code = "";

// customization
global.player_name = "Player";

// gameplay

global.shadow_surface = -1;

// game settings

global.ray_tracing = false;
global.sound_volume = 0.5;
global.music_volume = 0.25;
