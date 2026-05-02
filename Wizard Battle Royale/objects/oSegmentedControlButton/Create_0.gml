type = "";

text = "";

font = global.default_font;

enabled = true;
hovered = false;

selected = false;

unselect_group_members = function() {
	var assets = tag_get_asset_ids(asset_get_tags(object_index), asset_object);
	
	for (var i = 0; i < array_length(assets); i++) {
		with (assets[i]) {
			selected = false;
		}
	}	
}


click_action = function() {
	// nothing for now;
}