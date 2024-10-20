extends Node

enum { MAIN_MENU, OPTIONS, PAUSE, MAIN_GAME, CREDITS }

var pause_menu
var options_menu

var active_menu

var objective
var mouse_captured = false

var is_story_told = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active_menu = MAIN_MENU
	objective = "Objective: Retrieve the files for No. 067 and get out safely."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_menu(menu: int) -> String:
	var menus = [
		"res://menus/menu.tscn",
		"res://menus/options.tscn",
		"res://menus/pause.tscn",
		"res://test_main.tscn",
		"res://menus/credits.tscn"
	]
	return menus[menu]
