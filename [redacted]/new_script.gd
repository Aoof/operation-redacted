extends Node


# Called when the node enters the scene tree
func _ready() -> void:
	Globals.current_room_node = $CurrentRoom
	Globals.switch_room("ok")  # Load the initial room

# Handle input for switching rooms
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		var pauseMenu = load(Globals.get_menu(Globals.PAUSE))
		Globals.pause_menu = pauseMenu.instantiate()
		add_child(Globals.pause_menu)
