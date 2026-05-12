id_ = -1;

spell = Spell.NONE;

depth = 10;

focused = false;

request_loot = function() {
	packet_send(oClientHandler.client, packet_create(NWTarget.HOST, PacketType.CL_REQ_SPELL_GET,
		{id: id_}));
}

can_be_collected = true;