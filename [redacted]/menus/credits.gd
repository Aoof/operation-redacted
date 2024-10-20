extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/Panel/BackButton.grab_focus()
	Globals.active_menu = Globals.CREDITS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if (Globals.active_menu != Globals.CREDITS): return
	get_tree().change_scene_to_file(Globals.get_menu(Globals.MAIN_MENU))
