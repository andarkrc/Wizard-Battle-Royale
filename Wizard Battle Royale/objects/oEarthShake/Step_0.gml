var _dt = delta_time / 1000000;
vertical_speed += g * _dt;

x += horizontal_speed * _dt;
y += vertical_speed * _dt;

var total_speed = abs(horizontal_speed) + abs(vertical_speed);


var collided_players = ds_list_create();
var collision_no = collision_ellipse_list(bbox_left, bbox_top, bbox_right, bbox_bottom, oPlayer, false, false, collided_players, false);

for (var i = 0; i < collision_no; i++) {
	var player = collided_players[| i];
	if (player.id_ == caster_id) continue;
	if (caster_id != oClientHandler.client_id) continue;
	
	packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_SPELLHIT, 
	{spell_id: spell_id, target: player.id_, should_destroy: false}));
}
ds_list_destroy(collided_players);

instance_destroy();