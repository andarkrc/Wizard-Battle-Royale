var _dt = delta_time / 1000000;

if (broken) {
	cloud_timer -= _dt;
	
	if (random(1) < 15 * _dt) { // Spawn particles over time
		part_particles_create(oGameplayHandler.particle_system, x + random_range(-15, 15), y + random_range(-15, 15), pt_cloud, 1);
	}
	
	if (!cloud_hit_local) {
		with (oPlayer) {
			if (id_ == oClientHandler.client_id) {
				if (point_distance(x, y, other.x, other.y) <= other.cloud_radius) {
					other.cloud_hit_local = true;
					packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_POTION_CLOUD_HIT, {target_id: id_}));
				}
			}
		}
	}
	
	if (cloud_timer <= 0) {
		instance_destroy();
	}
	
	return; // Do not execute movement code while broken
}

var collisions_all = [oCollisionBox, oCollisionBoxTopOnly]
var collisions_full = oCollisionBox;
var collisions_top = [oCollisionBox, oCollisionBoxTopOnly];
		
var hit_vertical = false;
if (vertical_speed > 0) {
	var collision_vertical = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + vertical_speed * _dt, collisions_top, false, true);
	if (collision_vertical != noone) {
		hit_vertical = true;
		while (collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, false) == noone) {
			y += 1;
		}
		vertical_speed = 0;
	}
} else if (vertical_speed < 0) {
	var collision_vertical = collision_rectangle(bbox_left, bbox_top + vertical_speed * _dt, bbox_right, bbox_top, collisions_full, false, false);
	if (collision_vertical != noone) {
		hit_vertical = true;
		while (collision_rectangle(bbox_left, bbox_top - 1, bbox_right, bbox_top, collisions_full, false, false) == noone) {
			y -= 1;
		}
		vertical_speed = 0;
	}
}

var distance_horizontal = horizontal_speed * _dt;
var distance_vertical = vertical_speed * _dt;

var collisions = move_and_collide(distance_horizontal, distance_vertical, oCollisionBox);
	
var collision_down = collision_rectangle(bbox_left, bbox_bottom, bbox_right, bbox_bottom + 1, collisions_top, false, true);
	
if (collision_down == noone) {
	vertical_speed += g * _dt;
} else {
	vertical_speed = 0;
}

if (thrown) {
	var hit_something = false;
	if (hit_vertical || collision_down != noone || array_length(collisions) > 0) {
		hit_something = true;
	}
	
	var collided_players = ds_list_create();
	var collision_no = collision_rectangle_list(bbox_left, bbox_top, bbox_right, bbox_bottom, oPlayer, false, false, collided_players, false);
	for (var i = 0; i < collision_no; i++) {
		if (collided_players[| i].id_ != thrower_id) {
			hit_something = true;
			break;
		}
	}
	ds_list_destroy(collided_players);
	
	if (hit_something) {
		horizontal_speed = 0;
		vertical_speed = 0;
	}
}

can_be_collected = (horizontal_speed == 0 && vertical_speed == 0);

if (thrown && can_be_collected && !broken) {
	broken = true;
	can_be_collected = false;
	
	// Initial visual particle explosion
	part_particles_create(oGameplayHandler.particle_system, x, y, pt_cloud, 40);
}