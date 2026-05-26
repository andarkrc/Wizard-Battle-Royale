// Inherit the parent event
event_inherited();

button_asset_type = oScrollListButton;

parent_node = undefined;

buttons_node = undefined;

ScrollButton = function(text = "", text_right = "", data = {}) constructor {
	self.text = text;
	self.text_right = text_right;
	self.data = data;
}

button_filter = function(button, idx) {
	return true;
}

buttons = [];
displayed_buttons = [];

last_buttons_number = 0;

top_padding = 0;
left_padding = 0;

list_height = 0;

can_scroll = true;

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

filter_buttons = function() {
	displayed_buttons = array_filter(buttons, button_filter);
}

update_contents = function() {
	clean_contents();
	filter_buttons();
	for (var i = 0; i < array_length(displayed_buttons); i++) {
		var node_struct = {
			width: "90%",
			height: "10%",
			maxHeight: 64,
			layerElements: [
				{
					type: "Instance", 
					instanceObjectIndex: button_asset_type,
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
		object_ref.text_right = displayed_buttons[i].text_right;
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
	
	update_style_params();
}

update_buttons_scroll = function() {
	flexpanel_node_style_set_position(buttons_node, flexpanel_edge.top, floor(scroll_offset), flexpanel_unit.point);
	update_parent_node();
}

update_style_params = function() {
	var buttons_node_struct = flexpanel_node_get_struct(buttons_node);
	top_padding = buttons_node_struct.paddingTop;
	left_padding = buttons_node_struct.paddingLeft;
	gap = buttons_node_struct.gapRow;
	
	var child_no = flexpanel_node_get_num_children(buttons_node);
	if (child_no != 0) {
		var pos_button = flexpanel_node_layout_get_position(flexpanel_node_get_child(buttons_node, 0), false);
		scroll_button_height = pos_button.height + 3; // idk y it needs more extra space
		scroll_button_width = pos_button.width;
	}
	
	list_height = flexpanel_node_layout_get_position(parent_node, false).height;
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
	update_style_params();
	
	var list_scroll_node = flexpanel_node_get_child(parent_node, "ListScroll");
	var ls_struct = flexpanel_node_get_struct(list_scroll_node);
	
	ls_struct.layerElements[0].instanceId.parent = id;
}