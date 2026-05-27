type = "";
hovered = false;
enabled = true;
level = 0;

hover_check = function(_x, _y) {
	return point_in_rectangle(_x, _y, x, y, x + sprite_width, y + sprite_height);
}