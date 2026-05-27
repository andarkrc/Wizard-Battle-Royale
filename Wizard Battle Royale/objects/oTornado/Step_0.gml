var _dt = delta_time / 1000000;
vertical_speed += g * _dt;

x += horizontal_speed * _dt;
y += vertical_speed * _dt;

if (image_xscale < max_scale) {
	image_xscale += growth_rate * _dt;
	image_yscale += growth_rate * _dt;
}

var total_speed = abs(horizontal_speed) + abs(vertical_speed);

var _particle_count = 3; 
var _radius = 24 * image_xscale;

var move_dir = darctan2(vertical_speed, -horizontal_speed);
var particles = particle_get_type(psTornado, 0);

part_type_direction(particles, 60, 115, 0, 10);

repeat (_particle_count) {
	var _ang = random(360);
	var _dist = random(_radius);
	
	var _p_x = x + lengthdir_x(_dist, _ang) + (horizontal_speed * _dt);
	var _p_y = y + lengthdir_y(_dist * 0.4, _ang) + (vertical_speed * _dt);
	
	part_particles_create(oGameplayHandler.particle_system, _p_x, _p_y, particles, 1);
}

mask_index = sTornadoObjectCollision;
var collision = collision_ellipse(bbox_left, bbox_top, bbox_right, bbox_bottom, oCollisionBox, false, true);
mask_index = sTornado;

if (collision != noone) {
	instance_destroy();
}