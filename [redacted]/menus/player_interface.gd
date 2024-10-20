extends Control

var resource = preload("res://assets/dialogues/initial.dialogue")
var title = "home"

var content : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	content = $Content
	if not Globals.is_story_told:
		Globals.is_story_told = true
		get_tree().paused = true
		
		var balloon = load("res://menus/custom_dialogue/balloon.tscn").instantiate()
		self.add_child(balloon)
		balloon.start(resource, title)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	content.text = Globals.objective
