extends Node2D

func _process(delta):
	global_position = get_global_mouse_position();
	Global.mouse_pos = global_position;
	pass
