var _dt = delta_time  / 1000000;
vertical_speed += g * _dt;

x += horizontal_speed * _dt;
y += vertical_speed * _dt;

var total_speed = abs(horizontal_speed) + abs(vertical_speed);


var move_dir = darctan2(vertical_speed, -horizontal_speed);
var particles = particle_get_type(psFireball, 1);
part_type_size(particles, 0.5, 0.5, 0, 0.1);
part_type_life(particles, 5, clamp(total_speed / 20, 5, max_particle_life));
part_type_direction(particles, move_dir, move_dir, 0, 5);
part_particles_create(oGameplayHandler.particle_system, x, y, particles, 2);

var collision = collision_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, oCollisionBox, false, true);
var collided_players = ds_list_create();
var collision_no = collision_ellipse_list(bbox_left, bbox_top, bbox_right, bbox_bottom, oPlayer, false, false, collided_players, false);
var hit_another_player = false;
for (var i = 0; i < collision_no; i++) {
	var player = collided_players[| i];
	if (player.id_ == caster_id) continue;
	if (caster_id != oClientHandler.client_id) continue;
	
	hit_another_player = true;
	packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_SPELLHIT, 
	{spell_id: spell_id, target: player.id_, should_destroy: true}));
}
ds_list_destroy(collided_players);

if (caster_id == oClientHandler.client_id && hit_another_player) {
	instance_destroy();
}

if (collision != noone) {
	instance_destroy();
}

