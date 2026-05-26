// Inherit the parent event
event_inherited();

parent = undefined;

data = {};

level = 1;

right_click_action = function()
{
	
}

hover_check = function(_x, _y)
{
	if (parent == undefined) {
		return point_in_rectangle(_x, _y, x, y, x + sprite_width, y + sprite_height);
	}
	
	var outside = false;
	
	if (x + sprite_width < parent.x) {
		outside = true;
	}
	if (x > parent.x + parent.sprite_width) {
		outside = true;
	}
	if (y + sprite_height < parent.y) {
		outside = true;
	}
	if (y > parent.y + parent.sprite_height) {
		outside = true;
	}
	
	if (outside) {
		instance_deactivate_object(id);
		return false;
	}
	
	var x1 = max(x, parent.x);
	var y1 = max(y, parent.y);
	var x2 = min(x + sprite_width, parent.x + parent.sprite_width);
	var y2 = min(y + sprite_height, parent.y + parent.sprite_height);
	
	return point_in_rectangle(_x, _y, x1, y1, x2, y2);
}