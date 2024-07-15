extends Node

var connect_scene_packed = preload("res://game_logic/connect.tscn")
var game_scene_packed = preload("res://game_logic/game.tscn")

var connect_scene
var game_scene

# should be called as deferred
func load_game_deferred():
	var root = get_tree().root
	connect_scene = root.get_child(root.get_child_count() - 1)
	connect_scene.visible = false
	print(";loading game")

	game_scene = game_scene_packed.instantiate()
	root.add_child(game_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = game_scene
	
	await get_tree().create_timer(5).timeout
	connect_scene.free()

func load_menu_deferred():
	var root = get_tree().root
	game_scene.visible = false

	connect_scene = connect_scene_packed.instantiate()
	root.add_child(connect_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = connect_scene
	
	await get_tree().create_timer(5).timeout
	game_scene.free()
