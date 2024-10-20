extends CharacterBody3D

@onready var spring_arm = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D
@onready var character_model = $CharacterModel  # Reference to the CharacterModel node
@onready var animation_player = $CharacterModel/AnimationPlayer  # Reference the AnimationPlayer inside CharacterModel

# Optimized variables
@export var movement_speed: float = 7.0
@export var run_speed: float = 12.0
var camera_angle: float = -20.0  # Slight downward tilt
var camera_distance: float = 7.0  # Closer distance to the character
var camera_height_offset: float = 6.0  # Raise the camera to center character
var smooth_time: float = 0.1  # Camera follow smoothing
var rotation_speed: float = 7.0  # Speed of character rotation
var rotation_step: float = 1.0  # How much to rotate per frame when turning (adjust for sensitivity)

var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Set the spring arm position and camera tilt
	spring_arm.position = position
	spring_arm.rotation_degrees.x = camera_angle
	spring_arm.spring_length = camera_distance
	spring_arm.position = Vector3(0, camera_height_offset, 0)  # Adjust camera height
	
func _physics_process(delta: float) -> void:
	var move_direction := Vector3.ZERO
	
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("down") - Input.get_action_strength("up")
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	var current_speed = movement_speed

	var is_running = Input.is_action_pressed("ui_shift")
	if is_running:
		current_speed = run_speed
	
	velocity.x = move_direction.x
	velocity.z = move_direction.z
	#velocity.y -= 20 * delta # no collision with floor
	
	velocity = velocity * current_speed
	move_and_slide()
	
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		var target_rotation_y = look_direction.angle()
		
		# Smoothly interpolate the character's rotation towards the target rotation
		character_model.rotation.y = lerp_angle(character_model.rotation.y, target_rotation_y, rotation_speed * delta)

	
	update_animation(move_direction, is_running)

# Called every frame
func _process(delta: float) -> void:
	spring_arm.position = position
	
	#handle_movement(delta)
	#update_camera_position()

# Handle player movement
func handle_movement(_delta: float) -> void:
	var direction = Vector3.ZERO

	# Rotate the character smoothly when pressing A (left) or D (right)
	if Input.is_action_pressed("left"):
		rotation.y += rotation_step * _delta  # Rotate left
	elif Input.is_action_pressed("right"):
		rotation.y -= rotation_step * _delta  # Rotate right

	# Detect input for forward/backward movement relative to the character's local orientation
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z  # Move forward in character's local space
	if Input.is_action_pressed("backward"):
		direction += transform.basis.z  # Move backward in character's local space

	direction = direction.normalized()

	var is_running = Input.is_action_pressed("ui_shift")
	var current_speed = movement_speed
	if is_running:
		current_speed = run_speed

	# Apply movement relative to the character's local space
	velocity = direction * current_speed
	move_and_slide()

	# No longer using the rotation in `direction` because we're handling the rotation with A and D keys.
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
	# Set the camera's target position directly above the character
	var camera_target_position = global_transform.origin + Vector3(0, camera_height_offset, 0)  # Adjust height above character

	# Use interpolation to move the camera smoothly to the target position
	camera.global_transform.origin = camera.global_transform.origin.lerp(camera_target_position, smooth_time)

	# Ensure the camera is looking at the character
	camera.look_at(global_transform.origin, Vector3.UP)
