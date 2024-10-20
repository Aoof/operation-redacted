extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()
	Globals.active_menu = Globals.MAIN_MENU

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	if (Globals.active_menu != Globals.MAIN_MENU): return
	Globals.is_story_told = false
	get_tree().change_scene_to_file(Globals.get_menu(Globals.MAIN_GAME))


func _on_option_button_pressed() -> void:
	if (Globals.active_menu != Globals.MAIN_MENU): return
	var optionsMenu = load(Globals.get_menu(Globals.OPTIONS))
	Globals.options_menu = optionsMenu.instantiate()
	add_child(Globals.options_menu)


func _on_quit_button_pressed() -> void:
	if (Globals.active_menu != Globals.MAIN_MENU): return
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	if (Globals.active_menu != Globals.MAIN_MENU): return
	get_tree().change_scene_to_file(Globals.get_menu(Globals.CREDITS))
