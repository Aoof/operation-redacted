extends Control

var resource = preload("res://assets/dialogues/initial.dialogue")
var title = "home"

@onready var content : RichTextLabel = $Content
@onready var prompt : RichTextLabel = $Prompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_as_top_level(true)
	if not Globals.is_story_told:
		Globals.is_story_told = true
		get_tree().paused = true
		
		var balloon = load("res://menus/custom_dialogue/balloon.tscn").instantiate()
		self.add_child(balloon)
		balloon.start(resource, title)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	content.text = Globals.objective
	prompt.text = Globals.user_prompt
