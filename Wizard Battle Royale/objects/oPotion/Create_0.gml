event_inherited();

id_ = -1;
potion = Potion.NONE;

image_speed = 0;

depth = 5;

can_be_collected = true;

focused = false;

thrown = false;
thrower_id = -1;
cloud_radius = METER;
throw_speed = 10 * METER;

broken = false;
cloud_timer = 3.0;
cloud_hit_local = false;

target_x = -1;
target_y = -1;
seeking_target = false;

request_loot = function() {
	packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_POTION_GET,
		{id: id_}));
}

cloud_collision = ds_list_create();

break_sound = -1;