if (!enabled || !visible ||  !layer_get_visible(layer)) exit;

if (mouse_check_button_released(mb_left) && hovered)
{
	click_action();
}