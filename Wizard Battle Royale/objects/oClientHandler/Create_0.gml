client = network_create_socket(network_socket_tcp);

is_connected = network_connect(client, global.server_ip, global.server_port);

client_id = -1;
is_host = false;
ping_received = true;

var keep_alive_callback = function()
{
	if (ping_received == false) {
		show_debug_message($"No longer connected to server");
	}
	ping_received = false;
	
	packet_send(client, packet_create(NWTarget.SERVER, PacketType.CL_PING));
}

keep_alive = time_source_create(time_source_game, 10, time_source_units_seconds, keep_alive_callback, [], -1);
time_source_start(keep_alive);

disconnect_procedure = function() {
	game_end();
}

listeners = ds_map_create();
events = ds_map_create();

cleaned = false;

/// @desc Signals a particular event to everybody subscribed to it.
/// @arg {Struct} event
signal = function(event) {
	if (!ds_map_exists(events, event.type)) {
		return;
	}
	// Call the callback for this event.
	var func = events[? event.type].func;
	func(event);
}

/// @desc Subscribes an object instance to an event.
/// @arg {Asset.GMObject} _id
/// @arg {String} event_type
/// @arg {Function} callback
subscribe = function(_id, event_type, callback) {
	if (!ds_map_exists(events, event_type)) {
		events[? event_type] = {id: _id, func: callback};
		
		
		if (!ds_map_exists(listeners, _id)) {
			ds_map_add(listeners, _id, []);
		}
		var subs = listeners[? _id];
		if (array_contains(subs, event_type)) {
			return;
		}
		array_push(subs, event_type);
	} else {
		unsubscribe(events[? event_type].id, event_type);
		subscribe(_id, event_type, callback);
	}
}

/// @desc Unsubscribes a listener from an event.
/// @arg {Asset.GMObject} _id
/// @arg {String} event_type
unsubscribe = function(_id, event_type) {
	if (cleaned) return;
	if (!ds_map_exists(events, event_type)) {
		return;
	}
	ds_map_delete(events, event_type);
	var subs = listeners[? _id];
	var idx = -1;
	for (var i = 0; i < array_length(subs); i++) {
		if (subs[i] == event_type) {
			idx = i;
			break;
		}
	}
	array_delete(subs, idx, 1);
	if (array_length(subs) == 0) {
		ds_map_delete(listeners, _id);
	}
}

/// @desc Unsubscribes a listener from every event.
/// @arg {Asset.GMObject} _id
unsubscribe_all = function(_id) {
	if (cleaned) return;
	if (!ds_map_exists(listeners, _id)) {
		return;
	}
	
	var subs = listeners[? _id];
	
	for (var i = 0; i < array_length(subs); i++) {
		ds_map_delete(events, subs[i]);
	}
	
	ds_map_delete(listeners, _id);
}