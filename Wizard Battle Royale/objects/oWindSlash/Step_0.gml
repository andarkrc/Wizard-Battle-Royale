var _dt = delta_time  / 1000000;

x += horizontal_speed * _dt;
y += vertical_speed * _dt;


var particles = particle_get_type(psWind, 0);
part_type_direction(particles, image_angle, image_angle, 0, 5);
part_type_orientation(particles, image_angle, image_angle, 0, 0, false);
var distribution = random_range(y - bbox_top, y - bbox_bottom);
var offx = lengthdir_x(distribution, image_angle + 90);
var offy = lengthdir_y(distribution, image_angle + 90);
offx -= lengthdir_x(32, image_angle);
offy -= lengthdir_y(32, image_angle);
part_particles_create(oGameplayHandler.particle_system, x + offx, y + offy, particles, 1);


mask_index = sWindslashCollision;
var collision = collision_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, oCollisionBox, false, true);
var collided_players = ds_list_create();
mask_index = sWindSlash;
var collision_no = collision_ellipse_list(bbox_left, bbox_top, bbox_right, bbox_bottom, oPlayer, false, false, collided_players, false);
var hit_another_player = false;
for (var i = 0; i < collision_no; i++) {
	var player = collided_players[| i];
	if (player.id_ == caster_id) continue;
	if (caster_id != oClientHandler.client_id) continue;
	if (ds_map_exists(players_hit, player.id_)) continue;
	
	ds_map_add(players_hit, player.id_, true);
	packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_SPELLHIT, 
	{spell_id: spell_id, target: player.id_, should_destroy: false}));
}
ds_list_destroy(collided_players);

if (collision != noone) {
	instance_destroy();
}

