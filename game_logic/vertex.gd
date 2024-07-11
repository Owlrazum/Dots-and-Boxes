class_name Vertex extends MeshInstance3D

signal vertex_pressed(vertex)

@onready var selectable = $Selectable

var pos: Vector2i

func _ready():
	selectable.selected.connect(on_selected)

func on_selected():
	vertex_pressed.emit(self)

func default():
	material_override.set_shader_parameter("color", Color.WHITE)

func highlight():
	material_override.set_shader_parameter("color", Color.GREEN_YELLOW)

func select():
	material_override.set_shader_parameter("color", Color.RED)
	
	
#func tween_mat(material, tween_values, parameter_name):
	#var tween = get_tree().create_tween()
	#var set_tear := func(v): material.set_shader_parameter(parameter_name, v)
	#tween.tween_method(set_tear, tween_values.x, tween_values.y, tear_time)
	#tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	#return tween.finished
