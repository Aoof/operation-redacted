extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
 
func _input(_event: InputEvent) -> void:
	pass


func _on_door_4_collider_body_entered(_body: Node3D) -> void:
	Globals.attempt_room_switch("up")


func _on_door_4_collider_body_exited(_body: Node3D) -> void:
	pass # Replace with function body.


func _on_door_3_collider_body_entered(_body: Node3D) -> void:
	Globals.attempt_room_switch("down")


func _on_door_3_collider_body_exited(_body: Node3D) -> void:
	pass # Replace with function body.


func _on_door_2_collider_body_entered(_body: Node3D) -> void:
	Globals.attempt_room_switch("left")


func _on_door_2_collider_body_exited(_body: Node3D) -> void:
	pass # Replace with function body.


func _on_door_1_collider_body_entered(_body: Node3D) -> void:
	Globals.attempt_room_switch("right")


func _on_door_1_collider_body_exited(_body: Node3D) -> void:
	pass # Replace with function body.
