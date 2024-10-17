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

# Called when the node enters the scene tree
func _ready() -> void:
	switch_room("ok")  # Load the initial room

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

# Handle input for switching rooms
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):  # "w" key for up
		attempt_room_switch("up")
	elif event.is_action_pressed("ui_down"):  # "s" key for down
		attempt_room_switch("down")
	elif event.is_action_pressed("ui_left"):  # "a" key for left
		attempt_room_switch("left")
	elif event.is_action_pressed("ui_right"):  # "d" key for right
		attempt_room_switch("right")

# Helper function to attempt switching rooms in a direction
func attempt_room_switch(direction: String) -> void:
	var neighbors = room_graph.get(current_room_name, {})
	if direction in neighbors:
		switch_room(neighbors[direction])
	else:
		print("No room in the direction: %s" % direction)
