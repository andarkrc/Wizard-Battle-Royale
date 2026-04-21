selected = false;
type = "";

font = fnArial12;

text = "";

ghost_text = "";

can_write = false;

cursor_index = 1;

width = 0;
height = 0;

blink = true;

blink_state_change = function() {
	blink = !blink;
}

blink_state_timer = time_source_create(time_source_game, 0.5, time_source_units_seconds, blink_state_change, [], -1);

action = function() {
	
}
