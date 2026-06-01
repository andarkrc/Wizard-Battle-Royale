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

move();

var hit_something = false;
if (thrown) {
	if (collision_rectangle(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, [oCollisionBox, oCollisionBoxTopOnly], false, false)) {
		hit_something = true;
	}
	
	var collided_players = ds_list_create();
	var col_no = collision_rectangle_list(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, oPlayer, false, false, collided_players, false);
	for (var i = 0; i < col_no; i++) {
		if (collided_players[| i].id_ == thrower_id) {
			continue;
		}
		hit_something = true;
		break;
	}
	ds_list_destroy(collided_players);
}

can_be_collected = (horizontal_speed == 0 && vertical_speed == 0);

if (thrown && !can_be_collected && !broken && hit_something) {
	broken = true;
	can_be_collected = false;
	break_sound = audio_play_sound_at(sndPotionBreak, x, y, 0, global.fallof_ref, global.fallof_max, 1, false, 1);
}