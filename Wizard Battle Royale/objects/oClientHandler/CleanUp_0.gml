time_source_destroy(keep_alive);
network_destroy(client);
ds_map_destroy(listeners);
ds_map_destroy(events);

cleaned = true;