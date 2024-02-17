extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.show_player_controls == true:
		$container/tooltips/tooltips_button.button_pressed = true
	else:
		$container/tooltips/tooltips_button.button_pressed = false
	
	$container/volume/HSlider.value = Global.volume
	$container/window/window_button.selected = Global.resolution_setting
	$container/resolution/resolution_button.selected = Global.window_setting

func _on_h_slider_changed():
	Global.volume = $container/volume/HSlider.value

func _on_close_pressed():
	$".".visible = false

func _on_resolution_button_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1280, 1024))
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		2:
			DisplayServer.window_set_size(Vector2i(1440, 900))
		3:
			DisplayServer.window_set_size(Vector2i(1366, 768))
		4:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		5:
			DisplayServer.window_set_size(Vector2i(2560, 1440))

func _on_window_button_item_selected(index):
	match index:
		0: #fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: #windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: #borderless windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: #borderless fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func _on_tooltips_button_pressed():
	Global.show_player_controls = !Global.show_player_controls
