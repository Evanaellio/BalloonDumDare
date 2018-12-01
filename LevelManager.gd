extends Node

var current_scene = null

var azerty = true
var current_level = 1
export (int) var MIN_LEVEL = 1
export (int) var MAX_LEVEL = 1

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_main_menu():
	goto_scene("res://Scenes/MainMenuScene.tscn")

func goto_credit_scene():
	goto_scene("res://Scenes/CreditsScene.tscn")
	
func goto_levels_scene():
	goto_scene("res://Scenes/LevelsScene.tscn")
	
func goto_options_scene():
	goto_scene("res://Scenes/OptionsScene.tscn")

func goto_level(level):
	if level < 0:
		goto_level(0)
	elif level <= MAX_LEVEL:
		current_level = level
		goto_scene("res://Scenes/Levels/Level" + str(level) + "Scene.tscn")
	else:
		current_level = MIN_LEVEL
		goto_credit_scene()

func goto_next_level():
	goto_level(current_level+1)

func goto_scene(path):
	print("loading " + path)
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.
	
	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)
	
	# Instance the new scene.
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)