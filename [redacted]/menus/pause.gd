extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/Panel/VBoxContainer/ContinueButton.grab_focus()
	Globals.active_menu = Globals.PAUSE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	if (Globals.active_menu != Globals.PAUSE): return
	get_tree().quit()


func _on_menu_button_pressed() -> void:
	if (Globals.active_menu != Globals.PAUSE): return
	get_tree().paused = false
	get_tree().change_scene_to_file(Globals.get_menu(Globals.MAIN_MENU))


func _on_options_button_pressed() -> void:
	if (Globals.active_menu != Globals.PAUSE): return
	var optionsMenu = load(Globals.get_menu(Globals.OPTIONS))
	Globals.options_menu = optionsMenu.instantiate()
	add_child(Globals.options_menu)


func _on_continue_button_pressed() -> void:
	if (Globals.active_menu != Globals.PAUSE): return
	get_tree().paused = false
	Globals.pause_menu.queue_free()
