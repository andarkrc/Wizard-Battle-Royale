id_ = -1;
potion = Potion.NONE;

g = 10 * METER;

horizontal_speed = 0;

vertical_speed = 0;

image_speed = 0;

depth = 5;

can_be_collected = true;

focused = false;

request_loot = function() {
	packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_POTION_GET,
		{id: id_}));
}