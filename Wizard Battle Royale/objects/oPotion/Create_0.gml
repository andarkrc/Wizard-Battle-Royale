id_ = -1;
potion = Potion.NONE;

g = 10 * METER;

horizontal_speed = 0;

vertical_speed = 0;

image_speed = 0;

depth = 5;

can_be_collected = true;

focused = false;

thrown = false;
thrower_id = -1;
cloud_radius = 64; // 1 METER
throw_speed = 10 * METER;

broken = false;
cloud_timer = 3.0;
cloud_hit_local = false;

pt_cloud_purple = part_type_create();
part_type_shape(pt_cloud_purple, pt_shape_smoke);
part_type_size(pt_cloud_purple, 0.5, 1.5, 0.02, 0);
part_type_color2(pt_cloud_purple, c_fuchsia, c_purple);
part_type_alpha3(pt_cloud_purple, 0.8, 0.5, 0);
part_type_life(pt_cloud_purple, 30, 50);
part_type_direction(pt_cloud_purple, 0, 360, 0, 0);
part_type_speed(pt_cloud_purple, 0.5, 2, -0.02, 0);

request_loot = function() {
	packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_POTION_GET,
		{id: id_}));
}