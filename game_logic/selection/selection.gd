class_name Selection extends RayCast3D

var _camera: Camera3D
var _hovered: Selectable


func _ready():
	_camera = get_node("..") as Camera3D


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		target_position = _camera.project_local_ray_normal(event.position) * 100
	elif event is InputEventMouseButton:
		var click = event as InputEventMouseButton
		if click.button_index == 1 and click.pressed:
			var selectable = get_collider() as Selectable
			if selectable:
				selectable.selected.emit()


func _physics_process(_delta):
	if not is_colliding():
		if _hovered:
			_hovered.hover_ended.emit()
			_hovered = null
		return
	
	var selectable = get_collider() as Selectable
	if selectable:
		if _hovered and selectable != _hovered:
			_hovered.hover_ended.emit()
			_hovered = null
		elif !_hovered:
			selectable.hover_started.emit()
			_hovered = selectable
