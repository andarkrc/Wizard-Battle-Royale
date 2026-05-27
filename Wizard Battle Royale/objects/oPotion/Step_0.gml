var _dt = delta_time / 1000000;

if (broken) {
	cloud_timer -= _dt;
	
	if (potion == Potion.BLINDING) {
		if (random(1) < 150 * _dt) { // Spawn particles over time
			var r = random(cloud_radius);
			var dir = random(360);
			part_particles_create(oGameplayHandler.particle_system, x + lengthdir_x(r, dir), y - 64 + lengthdir_y(r, dir), oGameplayHandler.pt_cloud_purple, 1);
		}
		
		var _in_cloud = false;
		with (oPlayer) {
			if (id_ == oClientHandler.client_id) {
				if (collision_circle(other.x, other.y - 32, other.cloud_radius, id, false, false) != noone) {
					_in_cloud = true;
				}
			}
		}
		if (_in_cloud) {
			if (!cloud_hit_local) {
				cloud_hit_local = true;
				packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_POTION_CLOUD_HIT, {target_id: oClientHandler.client_id, potion_type: Potion.BLINDING}));
			}
		} else {
			cloud_hit_local = false;
		}
	} else if (potion == Potion.REVERSE) {
		if (random(1) < 150 * _dt) { // Spawn particles over time
			var r = random(cloud_radius);
			var dir = random(360);
			part_particles_create(oGameplayHandler.particle_system, x + lengthdir_x(r, dir), y - 64 + lengthdir_y(r, dir), oGameplayHandler.pt_cloud_blue, 1);
		}
		
		var _in_cloud = false;
		with (oPlayer) {
			if (id_ == oClientHandler.client_id) {
				if (collision_circle(other.x, other.y - 32, other.cloud_radius, id, false, false) != noone) {
					_in_cloud = true;
				}
			}
		}
		if (_in_cloud) {
			if (!cloud_hit_local) {
				cloud_hit_local = true;
				packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_POTION_CLOUD_HIT, {target_id: oClientHandler.client_id, potion_type: Potion.REVERSE}));
			}
		} else {
			cloud_hit_local = false;
		}
	} else if (potion == Potion.BLINKING) {
		if (random(1) < 150 * _dt) { // Spawn particles over time
			var r = random(cloud_radius);
			var dir = random(360);
			part_particles_create(oGameplayHandler.particle_system, x + lengthdir_x(r, dir), y - 64 + lengthdir_y(r, dir), oGameplayHandler.pt_cloud_gold, 1);
		}
		
		var _in_cloud = false;
		with (oPlayer) {
			if (id_ == oClientHandler.client_id) {
				if (collision_circle(other.x, other.y - 32, other.cloud_radius, id, false, false) != noone) {
					_in_cloud = true;
				}
			}
		}
		if (_in_cloud) {
			if (!cloud_hit_local) {
				cloud_hit_local = true;
				packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_POTION_CLOUD_HIT, {target_id: oClientHandler.client_id, potion_type: Potion.BLINKING}));
			}
		} else {
			cloud_hit_local = false;
		}
	} else if (potion == Potion.FLAME) {
		if (random(1) < 300 * _dt) { // Spawn lots of fire particles smoothly
			var r = random(cloud_radius);
			var dir = random(360);
			var px = x + lengthdir_x(r, dir);
			var py = y - 64 + lengthdir_y(r, dir);
			part_particles_create(oGameplayHandler.particle_system, px, py, oGameplayHandler.pt_fire, 1);
		}
		
		with (oPlayer) {
			if (id_ == oClientHandler.client_id) {
				if (collision_circle(other.x, other.y - 32, other.cloud_radius, id, false, false) != noone) {
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
	if (potion == Potion.BLINDING) {
		cloud_timer = global.blinding_duration;
		for (var i = 0; i < 60; i++) {
			var r = random(cloud_radius);
			var dir = random(360);
			part_particles_create(oGameplayHandler.particle_system, x + lengthdir_x(r, dir), y - 64 + lengthdir_y(r, dir), oGameplayHandler.pt_cloud_purple, 1);
		}
	} else if (potion == Potion.FLAME) {
		cloud_timer = global.flame_duration;
		part_particles_create(oGameplayHandler.particle_system, x, y - 64, oGameplayHandler.pt_fire, 80);
		
		if (instance_exists(oInternalServer)) {
			var new_platform = {
				id: array_length(oInternalServer.spell_platforms),
				spell: Spell.FIREBALL,
				x: x,
				y: y
			};
			array_push(oInternalServer.spell_platforms, new_platform);
			packet_send(oClientHandler.client, packet_create(NWTarget.ALL, PacketType.HOST_SYNC_SPELL_PLATFORM, new_platform));
		}
	} else if (potion == Potion.REVERSE) {
		cloud_timer = global.reverse_duration;
		for (var i = 0; i < 60; i++) {
			var r = random(cloud_radius);
			var dir = random(360);
			part_particles_create(oGameplayHandler.particle_system, x + lengthdir_x(r, dir), y - 64 + lengthdir_y(r, dir), oGameplayHandler.pt_cloud_blue, 1);
		}
	} else if (potion == Potion.BLINKING) {
		cloud_timer = global.blinking_duration;
		for (var i = 0; i < 60; i++) {
			var r = random(cloud_radius);
			var dir = random(360);
			part_particles_create(oGameplayHandler.particle_system, x + lengthdir_x(r, dir), y - 64 + lengthdir_y(r, dir), oGameplayHandler.pt_cloud_gold, 1);
		}
	}
}