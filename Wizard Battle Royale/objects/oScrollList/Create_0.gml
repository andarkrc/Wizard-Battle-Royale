// Inherit the parent event
event_inherited();

parent_node = undefined;

buttons_node = undefined;

ScrollButton = function(_text = "", _data = {}) constructor {
	text = _text;
	data = _data;
}

button_filter = function(button, idx) {
	return true;
}

buttons = [];
displayed_buttons = [];

top_padding = 0;
left_padding = 0;

gap = 0;

scroll_button_height = 0;
scroll_button_width = 0;

scroll_offset = 0;

last_hovered_button = -1;

clean_contents = function() {
	var total_buttons = flexpanel_node_get_num_children(buttons_node);
	for (var i = 0; i < total_buttons; i++) {
		var child_node = flexpanel_node_get_child(buttons_node, i);
		var child_struct = flexpanel_node_get_struct(child_node);
		instance_destroy(child_struct.layerElements[0].instanceId);
		flexpanel_delete_node(child_node);
	}
	flexpanel_node_remove_all_children(buttons_node);
}

update_contents = function() {
	clean_contents();
	displayed_buttons = array_filter(buttons, button_filter);
	for (var i = 0; i < array_length(displayed_buttons); i++) {
		var node_struct = {
			width: "90%",
			height: "10%",
			maxHeight: 64,
			layerElements: [
				{
					type: "Instance", 
					instanceObjectIndex: oScrollListButton,
					flexVisible: 1,
					flexAnchor: "TopLeft",
					flexStretchWidth: 1,
					flexStretchHeight: 1,
				},
			]
		};
		
		var node = flexpanel_create_node(node_struct);
		var child_no = flexpanel_node_get_num_children(buttons_node);
		flexpanel_node_insert_child(buttons_node, node, child_no);
		
		var struct = flexpanel_node_get_struct(buttons_node);
		var object_ref = struct.nodes[child_no].layerElements[0].instanceId;
		object_ref.text = displayed_buttons[i].text;
		object_ref.data = displayed_buttons[i].data;
		object_ref.parent = id;
		object_ref.level = level + 1;
	}
	
	update_parent_node();
}

update_parent_node = function() {
	var pos = flexpanel_node_layout_get_position(parent_node);
	
	if (pos.width > 0) {
		flexpanel_calculate_layout(parent_node, pos.width, pos.height, flexpanel_direction.LTR);
	}
	
	var child_no = flexpanel_node_get_num_children(buttons_node);
	if (child_no != 0) {
		var pos_button = flexpanel_node_layout_get_position(flexpanel_node_get_child(buttons_node, 0));
		scroll_button_height = pos_button.height;
		scroll_button_width = pos_button.width;
	}
}

update_buttons_scroll = function() {
	flexpanel_node_style_set_position(buttons_node, flexpanel_edge.top, scroll_offset, flexpanel_unit.point);
	update_parent_node();
}

/// @desc adds a new button for total
/// @arg {Struct.ScrollButton} button
add_button = function(button) {
	array_push(buttons, button);
}

remove_all_buttons = function() {
	buttons = [];
	displayed_buttons = [];
}

find_my_parent_node = function(node) {
	var node_struct = flexpanel_node_get_struct(node);
	
	if (struct_exists(node_struct, "layerElements")) {
		var elements = node_struct.layerElements;
		for (var i = 0; i < array_length(elements); i++) {
			if (struct_exists(elements[i], "instanceId")) {
				if (elements[i].instanceId == id) {
					parent_node = node;
					return;
				}
			}
		}
	}
	
	var num_children = flexpanel_node_get_num_children(node);
	
	for (var i = 0; i < num_children && parent_node == undefined; i++) {
		find_my_parent_node(flexpanel_node_get_child(node, i));
	}
}

find_my_parent_node(layer_get_flexpanel_node(layer_get_name(layer)));
if (parent_node != undefined) {
	buttons_node = flexpanel_node_get_child(parent_node, "ScrollList");
	var buttons_node_struct = flexpanel_node_get_struct(buttons_node);
	top_padding = buttons_node_struct.paddingTop;
	left_padding = buttons_node_struct.paddingLeft;
	gap = buttons_node_struct.gapRow;
}