var _dt = delta_time / 1000000;

if (broken) {
	cloud_timer -= _dt;
	
	if (potion != Potion.FLAME) {
		cloud_timer = 0;
		var r = random(cloud_radius);
		var dir = random(360);
		var part = particle_get_type(psPotionCloud, 0);
		var c = potion_get_particle_colors(potion);
		part_type_colour3(part, c[0], c[1], c[2]);
		part_type_alpha3(part, 0.3, 0.2, 0.1);
		part_particles_create(oGameplayHandler.particle_system, x + lengthdir_x(r, dir), y + lengthdir_y(r, dir), part, 3);
		
		ds_list_clear(cloud_collision);
		var col_no = collision_circle_list(x, y, cloud_radius, oPlayer, false, false, cloud_collision, false);
		for (var i = 0; i < col_no; i++) {
			var player = cloud_collision[| i];
			packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_POTION_CLOUD_HIT, {target_id: player.id_, potion_type: potion}));
		}
	} else if (potion == Potion.FLAME) {
		if (random(1) < 300 * _dt) { // Spawn lots of fire particles smoothly
			var r = random(cloud_radius);
			var dir = random(360);
			var px = x + lengthdir_x(r, dir);
			var py = y + lengthdir_y(r, dir);
			part_particles_create(oGameplayHandler.particle_system, px, py, oGameplayHandler.pt_fire, 1);
		}
		
		with (oPlayer) {
			if (id_ == oClientHandler.client_id) {
				if (collision_circle(other.x, other.y, other.cloud_radius, id, false, false) != noone) {
					if (!damaged && other.cloud_timer <= global.flame_duration - 2.0) { // Hit every 0.3s after 2s immunity
						packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_POTION_FIRE_HIT, {}));
					}
				}
			}
		}
	}
	
	if (cloud_timer <= 0) {
		instance_destroy();
	}
	
	exit; // Do not execute movement code while broken
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

var hit_something = false;
if (thrown) {
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
}

can_be_collected = (horizontal_speed == 0 && vertical_speed == 0);

if (thrown && !can_be_collected && !broken && hit_something) {
	broken = true;
	can_be_collected = false;
}