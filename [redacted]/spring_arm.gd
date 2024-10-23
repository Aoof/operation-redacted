extends SpringArm3D

var mouse_sensitivity := 0.05
var joystick_sensitivity := 1	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_joystick_input(delta)

func handle_joystick_input(_delta: float) -> void:
	var joystick_y := Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up")
	var joystick_x := Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
	
	# Rotate based on joystick input
	rotation_degrees.x -= joystick_y * joystick_sensitivity
	rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)

	rotation_degrees.y -= joystick_x * joystick_sensitivity
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
