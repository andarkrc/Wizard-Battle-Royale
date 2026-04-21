if (global.connection_type == "direct-host") {
	instance_create_layer(0, 0, "Instances", oServerHandler);
}
instance_create_layer(0, 0, "Instances", oClientHandler);
instance_create_layer(0, 0, "Instances", oGameplayHandler);