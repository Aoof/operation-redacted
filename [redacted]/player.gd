extends CharacterBody3D

@onready var spring_arm = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D
@onready var character_model = $CharacterModel  # Reference to the CharacterModel node
@onready var animation_player = $CharacterModel/AnimationPlayer  # Reference the AnimationPlayer inside CharacterModel

# Optimized variables
var movement_speed: float = 4.0
var run_speed: float = 7.0
var camera_angle: float = -20.0  # Slight downward tilt
var camera_distance: float = 7.0  # Closer distance to the character
var camera_height_offset: float = 6.0  # Raise the camera to center character
var smooth_time: float = 0.1  # Camera follow smoothing
var rotation_speed: float = 2.0  # Speed of character rotation

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Set the spring arm position and camera tilt
	spring_arm.rotation_degrees.x = camera_angle
	spring_arm.spring_length = camera_distance
	spring_arm.position = Vector3(0, camera_height_offset, 0)  # Adjust camera height

# Called every frame
func _process(delta: float) -> void:
	handle_movement(delta)
	update_camera_position()

# Handle player movement
func handle_movement(_delta: float) -> void:
	var direction = Vector3.ZERO

	# Detect input for movement relative to the character's local orientation
	if Input.is_action_pressed("up"):
		direction -= transform.basis.z  # Move forward in character's local space
	if Input.is_action_pressed("down"):
		direction += transform.basis.z  # Move backward in character's local space
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x  # Move left relative to the character's orientation
	if Input.is_action_pressed("right"):
		direction += transform.basis.x  # Move right relative to the character's orientation

	direction = direction.normalized()

	var is_running = Input.is_action_pressed("ui_shift")
	var current_speed = movement_speed
	if is_running:
		current_speed = run_speed

	# Apply movement relative to the character's local space
	velocity = direction * current_speed
	move_and_slide()

	# Smoothly rotate the character to face the direction of movement
	if direction != Vector3.ZERO:
		# Calculate the desired direction based on movement and smoothly rotate the character to face it
		var target_rotation = direction.angle_to(Vector3(0, 0, -1))  # We want the character to face the direction of movement
		rotation.y = lerp_angle(rotation.y, -target_rotation, rotation_speed * _delta)  # Smooth character rotation

	update_animation(direction, is_running)

# Update animations based on input
func update_animation(direction: Vector3, is_running: bool) -> void:
	if direction != Vector3.ZERO:
		if is_running:
			if animation_player.current_animation != "Running":
				animation_player.play("Running")
		else:
			if animation_player.current_animation != "Walk":
				animation_player.play("Walk")
	else:
		if animation_player.current_animation != "Idel":
			animation_player.play("Idel")

# Smooth camera follow logic
func update_camera_position() -> void:
	# Keep the camera behind the character at all times
	var camera_target_position = global_transform.origin - global_transform.basis.z * camera_distance

	# Use interpolation to move the camera smoothly to the target position
	camera.global_transform.origin = camera.global_transform.origin.lerp(camera_target_position, smooth_time)

	# Ensure the camera is looking at the character
	camera.look_at(global_transform.origin, Vector3.UP)
