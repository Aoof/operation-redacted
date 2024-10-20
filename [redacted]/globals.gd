extends Node


# A graph where each room name has a list of neighboring rooms
var room_graph = {
	"room1": {"right": "room2", "up": "room3", "left": "room5"},
	"room2": {"left": "room1", "right": "room4", "up": "room9"},
	"room3": {"down": "room1", "right": "room9", "up": "room16", "left": "room7"},
	"room4": {"left": "room2", "up": "room10"},
	"room5": {"right": "room1", "up": "room7", "left": "room6"},
	"room6": {"right": "room5", "up": "room9"},
	"room7": {"down": "room5", "right": "room3", "up": "room17", "left": "room8"},
	"room8": {"down": "room6", "right": "room7", "up": "room18"},
	"room9": {"down": "room2", "right": "room10", "up": "room15", "left": "room3"},
	"room10": {"down": "room4", "up": "room11", "left": "room9"},
	"room11": {"down": "room10", "right": "room12", "up": "room14", "left": "room15"},
	"room12": {"up": "room13", "left": "room11"},
	"room13": {"down": "room12", "left": "room14"},
	"room14": {"down": "room11", "right": "room13"}, # control room
	"room15": {"down": "room9", "right": "room11", "left": "room15"},
	"room16": {"down": "room3", "right": "room15", "left": "room17"},
	"room17": {"down": "room7", "right": "room16", "up": "room24", "left": "room18"},
	"room18": {"down": "room8", "right": "room17", "up": "room23", "left": "room19"},
	"room19": {"right": "room18", "up": "room22", "left": "room20"},
	"room20": {"right": "room19", "up": "room21"},
	"room21": {"down": "room20", "right": "room22"},
	"room22": {"down": "room19", "right": "room23", "left": "room21"},
	"room23": {"down": "room18", "right": "room24", "left": "room22"},
	"room24": {"down": "room17", "left": "room23"},
}

# Initialize with starting room
var current_room_name: String = "room1"

# Reference to the node where rooms are instantiated
@onready var current_room_node = $CurrentRoom

enum { MAIN_MENU, OPTIONS, PAUSE, MAIN_GAME, CREDITS }
enum { EMPTY, RETRIEVE_FILES, ESCAPE }

var objectives = [
	"",
	"Objective: Retrieve the files for No. 067.",
	"Objective: Run!"
]

var user_prompt = ""

var pause_menu
var options_menu

var active_menu

var objective
var mouse_captured = false

var is_story_told = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active_menu = MAIN_MENU
	objective = objectives[EMPTY]

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_menu(menu: int) -> String:
	var menus = [
		"res://menus/menu.tscn",
		"res://menus/options.tscn",
		"res://menus/pause.tscn",
		"res://test_main.tscn",
		"res://menus/credits.tscn"
	]
	return menus[menu]
	
# Function to switch rooms
func switch_room(new_room_name: String) -> void:
	if new_room_name == "ok":
		var new_room_scene = load("res://rooms/room1.tscn")
		var new_room = new_room_scene.instantiate()
		current_room_node.add_child(new_room)  # Add the new room to the CurrentRoom node
	elif new_room_name in room_graph.get(current_room_name, {}).values():
		# Free the old room
		if current_room_node.get_child_count() > 0:
			current_room_node.get_child(0).queue_free()  # Free the old room
		
		# Load and instance the new room
		var new_room_scene = load("res://rooms/%s.tscn" % new_room_name)
		var new_room = new_room_scene.instantiate()
		current_room_node.add_child(new_room)  # Add the new room to the CurrentRoom node
		
		# Update the current room
		current_room_name = new_room_name
		print("Switched to room: %s" % current_room_name)
	else:
		print("Invalid room transition!")

# Helper function to attempt switching rooms in a direction
func attempt_room_switch(direction: String) -> String:
	var neighbors = room_graph.get(current_room_name, {})
	if direction in neighbors:
		user_prompt = "Please press [color=green]the closest button to the right joystick[/color]"
		return neighbors[direction]
	else:
		user_prompt = "[color=red]This door is locked[/color]"
		
		var timer = Timer.new()
		timer.timeout = _on_timeout
		timer.start(3)
		return current_room_name

func _on_timeout():
	user_prompt = ""
