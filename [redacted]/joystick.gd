extends Node

var host = "127.0.0.1"
var port = 65432

var _status: int = 0
var _stream: StreamPeerTCP = StreamPeerTCP.new()

var _oldLJoy = []
var _oldRJoy = []
var _oldBtnd = []

signal connected()
signal disconnected()
signal error()

signal ljoy(newLJoy)
signal rjoy(newRJoy)
signal buttons(newBtnd)

func _ready():
	_status = _stream.get_status()
	connect_to_host()

func _physics_process(delta: float) -> void:
	_stream.poll()

func _process(delta):
	# Check if connected and data is available
	_stream.poll()
	var new_status: int = _stream.get_status()
	if new_status != _status:
		_status = new_status
		match _status:
			_stream.STATUS_NONE:
				print("Disconnected from host.")
				emit_signal("disconnected")
			_stream.STATUS_CONNECTING:
				print("Connecting to host.")
			_stream.STATUS_CONNECTED:
				print("Connected to host.")
				emit_signal("connected")
			_stream.STATUS_ERROR:
				print("Error with socket stream.")
				emit_signal("error")
	if _status == _stream.STATUS_CONNECTED:
		var available_bytes: int = _stream.get_available_bytes()
		var data = _stream.get_partial_data(available_bytes)
		
		# Check for read error.
		if data[0] != OK:
			print("Error getting data from stream: ", data[0])
			emit_signal("error")
		elif (data[1]):
			parse_data(data[1])

func parse_data(data):
	var decoded_data = data.get_string_from_utf8().strip_edges()
	var components = decoded_data.split("|")
	if len(components) == 2:
		var joystick_data = components[0].substr(2)
		var button_data = components[1].substr(2)
		
		var jd = []
		var btnd = []
		
		joystick_data = joystick_data.split(",")
		button_data = button_data.split(",")
		
		for n in joystick_data: jd.append(int(n))
		for n in button_data: btnd.append(int(n))
		
		var newLJoy = [jd[0], jd[1], jd[2]]
		var newRJoy = [jd[3], jd[4], jd[5]]

		emit_signal("ljoy", newLJoy)
		emit_signal("rjoy", newRJoy)
		emit_signal("buttons", btnd)

		_oldBtnd = btnd
		_oldRJoy = newRJoy
		_oldLJoy = newLJoy


func connect_to_host() -> void:
	print("Connecting to %s:%d" % [host, port])
	# Reset status so we can tell if it changes to error again.
	_status = _stream.STATUS_NONE
	if _stream.connect_to_host(host, port) != OK:
		print("Error connecting to host.")
		emit_signal("error")

func _exit_tree() -> void:
	if _stream:
		_stream.disconnect_from_host()
		print("Closed connection")
