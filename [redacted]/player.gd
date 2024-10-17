extends CharacterBody3D

@export var move_speed: float = 5.0  # Movement speed
@export var mouse_sensitivity: float = 0.3  # How sensitive the mouse rotation is
@onready var camera = $FirstPersonCamera  # Reference to the camera
var rotation_x: float = 0.0  # Used for up/down rotation (pitch)

# Called every frame, handles input and movement
func _process(delta: float) -> void:
	handle_mouse_input()
	handle_movement(delta)

# Mouse look logic
func handle_mouse_input() -> void:
	var mouse_delta = Input.get_last_mouse_motion()
	
	# Rotate the camera vertically (pitch) and limit the up/down look to avoid flipping
	rotation_x -= mouse_delta.y * mouse_sensitivity
	rotation_x = clamp(rotation_x, deg_to_rad(-80), deg_to_rad(80))  # Limit vertical look angle
	camera.rotation_degrees.x = rad_to_deg(rotation_x)  # Apply to camera

	# Rotate the player horizontally (yaw)
	rotation_degrees.y -= mouse_delta.x * mouse_sensitivity

# Movement logic
func handle_movement(delta: float) -> void:
	var velocity = Vector3.ZERO

	# Use arrow keys or WASD for movement
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_forward"):
		velocity.z -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_backward"):
		velocity.z += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		velocity.x += 1

	# Normalize movement direction so diagonal movement isn't faster
	if velocity.length() > 0:
		velocity = velocity.normalized() * move_speed

	# Move the player based on direction and speed
	velocity = global_transform.basis * velocity * delta  # Rotate movement relative to camera/player
	move_and_slide(velocity)
