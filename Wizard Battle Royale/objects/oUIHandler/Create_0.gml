should_stretch_view = false;

enum PopupType {
	ERROR,
	SONG,
	INFO
};

active_popup = noone;

popup_queue = [];

add_popup = function(title, description = "", type = PopupType.ERROR) {
	array_push(popup_queue, {title : title, description: description, type: type});
}

activate_popup = function() {
	active_popup = instance_create_layer(window_get_width() - 10, 10, "PopupLayer", oPopupBox,
	{
		title: popup_queue[0].title,
		description: popup_queue[0].description
	});
	switch (popup_queue[0].type) {
		case PopupType.SONG:
			active_popup.title_color = c_green;
			break;
		
		case PopupType.INFO:
			active_popup.title_color = c_yellow;
			break;
		
		default:
		case PopupType.ERROR:
			active_popup.title_color = #DD2233;
			break;
	}
	array_shift(popup_queue);
}