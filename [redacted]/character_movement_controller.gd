extends CharacterBody3D

@export var move_speed: float = 150.0  # Movement speed
@export var mouse_sensitivity: float = 0.2  # Mouse sensitivity for rotation
@onready var camera = $FirstPersonCamera  # Reference to the camera

var rotation_x: float = 0.0  # For up/down (pitch) rotation

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Hide and lock the cursor

# Called every frame to handle movement and rotation
func _process(delta: float) -> void:
	handle_movement(delta)

# Handle mouse input for first-person camera
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_delta = event.relative  # Get relative mouse movement
		
		# Rotate the camera vertically (pitch)
		rotation_x -= mouse_delta.y * mouse_sensitivity * 0.1
		rotation_x = clamp(rotation_x, deg_to_rad(-80), deg_to_rad(80))  # Limit up/down look
		camera.rotation_degrees.x = rad_to_deg(rotation_x)

		# Rotate the player horizontally (yaw)
		rotation_degrees.y -= mouse_delta.x * mouse_sensitivity

# Handle player movement based on input
func handle_movement(delta: float) -> void:
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("up") or Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("down") or Input.is_action_pressed("move_backward"):
		input_dir.z += 1
	if Input.is_action_pressed("left") or Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("right") or Input.is_action_pressed("move_right"):
		input_dir.x += 1

	# Normalize to prevent faster diagonal movement
	if input_dir.length() > 0:
		input_dir = input_dir.normalized() * move_speed

	# Apply rotation relative to the player and move using move_and_slide
	velocity = global_transform.basis * input_dir * delta  # Rotate based on player facing direction
	move_and_slide()  # Use the built-in move_and_slide method
