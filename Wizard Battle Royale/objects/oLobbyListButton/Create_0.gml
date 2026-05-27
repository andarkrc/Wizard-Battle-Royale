// Inherit the parent event
event_inherited();

selected = false;

click_action = function()
{
	global.lobby_code = data.code;
}

right_click_action = function()
{
	global.lobby_code = data.code;
	global.connection_role = "guest";
	deactivate_menus();
	room_goto(rmGame);
}