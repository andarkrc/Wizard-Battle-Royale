id_ = -1;

focused = false;

depth = 10;

potion = Potion.NONE;

request_loot = function() {
	packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_CHEST_OPEN,
		{id: id_}));
}

can_be_collected = true;