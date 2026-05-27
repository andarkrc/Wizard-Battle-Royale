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

var collisions = ds_list_create();
var coll_num = collision_ellipse_list(bbox_left, bbox_top, bbox_right, bbox_bottom, oSpellParent, false, true, collisions, false);

for (var i = 0; i < coll_num; i++) {
    var enemy_proj = collisions[| i];
    if (enemy_proj.object_index == oShield) {
        continue;    
    }
    
    if (enemy_proj.caster_id != caster_id) {
        with (enemy_proj) {
            instance_destroy();
        }
    }
}


var particles = particle_get_type(psShield, 0);
part_particles_create(oGameplayHandler.particle_system, x, y, particles, 1);