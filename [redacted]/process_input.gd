extends Node

func _ready() -> void:
	print("Number of connected joysticks: ", Input.get_connected_joypads())
	
func _process(delta: float) -> void:
	for i in range(JOY_AXIS_MAX):
		var axis_value = Input.get_joy_axis(0, i)
		if abs(axis_value) > 0.1:  # Threshold to filter small input noise
			print("Joystick axis", i, "value:", axis_value)

	for button in range(JOY_BUTTON_MAX):
		if Input.is_joy_button_pressed(0, button):
			print("Button", button, "pressed")
