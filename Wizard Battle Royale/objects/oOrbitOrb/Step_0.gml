var _dt = delta_time / 1000000;

lifetime -= _dt;
if (lifetime <= 0) {
	instance_destroy();
	exit;
}

var owner = noone;
with (oPlayer) {
	if (id_ == other.caster_id) {
		owner = id;
	}
}

if (owner != noone) {
	orbit_angle += rotation_speed * _dt;
	if (orbit_angle >= 360) orbit_angle -= 360;
	
	x = owner.x + lengthdir_x(orbit_radius, orbit_angle);
	y = owner.y + lengthdir_y(orbit_radius, orbit_angle);
} else {
	instance_destroy();
	exit;
}

var enemy_proj = collision_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, oSpreadShot, false, true);
if (enemy_proj == noone) enemy_proj = collision_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, oIceSpike, false, true);
if (enemy_proj == noone) enemy_proj = collision_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, oFireball, false, true);

if (enemy_proj != noone) {
	if (enemy_proj.caster_id != caster_id) {
		with (enemy_proj) {
			instance_destroy();
		}
	}
}

var particles = particle_get_type(psOrbitOrb, 0);
part_particles_create(oGameplayHandler.particle_system, x, y, particles, 1);

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