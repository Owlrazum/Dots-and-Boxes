class_name Vertex extends MeshInstance3D

signal vertex_pressed(vertex)

@onready var selectable = $Selectable

var pos: Vector2i
var prev_col

func _ready():
	selectable.selected.connect(on_selected)
	selectable.hover_started.connect(on_hover_start)
	selectable.hover_ended.connect(on_hover_end)

func on_selected():
	print("selected")
	vertex_pressed.emit(self)

func default():
	material_override.set_shader_parameter("color", Color.WHITE)

func highlight():
	material_override.set_shader_parameter("color", Color.GREEN_YELLOW)

func select():
	material_override.set_shader_parameter("color", Color.RED)

func on_hover_start():
	prev_col = material_override.get_shader_parameter("color")
	material_override.set_shader_parameter("color", Color.LIGHT_BLUE)

func on_hover_end():
	material_override.set_shader_parameter("color", Color.WHITE)

#func tween_mat(material, tween_values, parameter_name):
	#var tween = get_tree().create_tween()
	#var set_tear := func(v): material.set_shader_parameter(parameter_name, v)
	#tween.tween_method(set_tear, tween_values.x, tween_values.y, tear_time)
	#tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	#return tween.finished
