extends Control

var oldMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/Panel/Button.grab_focus()
	oldMenu = Globals.active_menu
	Globals.active_menu = Globals.OPTIONS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if (Globals.active_menu != Globals.OPTIONS): return
	Globals.options_menu.queue_free()
	Globals.active_menu = oldMenu
	
	var child = get_parent()
	while (child.get_child(0)): child = child.get_child(0)

	child.call_deferred("grab_focus")
