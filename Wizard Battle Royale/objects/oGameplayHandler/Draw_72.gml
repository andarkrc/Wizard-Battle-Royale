var cam = view_get_camera(0);

var xx = camera_get_view_x(cam);
var yy = camera_get_view_y(cam);

draw_sprite_tiled(sBackgroundSpace, 0, xx * 0.3, yy * 0.3);
