extends Node

@export var dims: Vector2i = Vector2i(4, 4)
@export var gap: float = 100
@export var vertex_size: float = 32

@export var cell_scene = preload("res://game_logic/cell.tscn")
@export var vertex_scene = preload("res://game_logic/vertex.tscn")
@export var edge_scene = preload("res://game_logic/edge.tscn")

@export var vertices_parent: Node
@export var edges_parent: Node

var selected_vertex: Vertex

func _ready():
	var delta = (vertex_size + gap) * Vector3(1, 0, 1)
	var start_delta = -delta;
	if dims.y % 2 == 0:
		start_delta.x /= 2;
		start_delta.z /= 2;

	var t = -(dims / 2.0 - Vector2(1, 1))
	var start_pos = Vector3(t.x * delta.x, 0, t.y * delta.z) + start_delta
	var pos = start_pos;
	
	var dots = []
	for r in dims.x:
		for c in dims.y:
			var vertex = vertex_scene.instantiate() as Vertex
			vertices_parent.add_child(vertex)
			vertex.position = pos
			dots.append(vertex)
			vertex.pos = Vector2i(r, c)
			vertex.vertex_pressed.connect(on_vertex_pressed)
			vertex.material_override = vertex.material_override.duplicate()

			pos.x += delta.x
		pos.x = start_pos.x
		pos.z += delta.z

func on_vertex_pressed(vertex):
	if selected_vertex:
		if is_adjacent(vertex, selected_vertex):
			selected_vertex.default()
			default_adjacent(selected_vertex)
			make_edge(selected_vertex, vertex)
			selected_vertex = null
	else:
		vertex.select()
		selected_vertex = vertex
		highlight_adjacent(vertex)

func is_adjacent(lh, rh):
	if (abs(lh.pos.x - rh.pos.x) == 1 and abs(lh.pos.y - rh.pos.y) == 0 or 
		abs(lh.pos.y - rh.pos.y) == 1 and abs(lh.pos.x - rh.pos.x) == 0):
		return true
	return false

func highlight_adjacent(vertex):
	if vertex.pos.x > 0:          vertices_parent.get_child(xytox(Vector2i(vertex.pos.x - 1, vertex.pos.y))).highlight()
	if vertex.pos.x < dims.x - 1: vertices_parent.get_child(xytox(Vector2i(vertex.pos.x + 1, vertex.pos.y))).highlight()
	if vertex.pos.y > 0:          vertices_parent.get_child(xytox(Vector2i(vertex.pos.x, vertex.pos.y - 1))).highlight()
	if vertex.pos.y < dims.x - 1: vertices_parent.get_child(xytox(Vector2i(vertex.pos.x, vertex.pos.y + 1))).highlight()

func default_adjacent(vertex):
	if vertex.pos.x > 0:          vertices_parent.get_child(xytox(Vector2i(vertex.pos.x - 1, vertex.pos.y))).default()
	if vertex.pos.x < dims.x - 1: vertices_parent.get_child(xytox(Vector2i(vertex.pos.x + 1, vertex.pos.y))).default()
	if vertex.pos.y > 0:          vertices_parent.get_child(xytox(Vector2i(vertex.pos.x, vertex.pos.y - 1))).default()
	if vertex.pos.y < dims.x - 1: vertices_parent.get_child(xytox(Vector2i(vertex.pos.x, vertex.pos.y + 1))).default()
	
func xytox(pos):
	return pos.x * dims.x + pos.y

func make_edge(v1, v2):
	var p = v1.position - v2.position
	var edge = edge_scene.instantiate() as Edge
	edges_parent.add_child(edge)
	edge.position = v2.position
	edge.look_at_from_position(v1.position, v2.position)
	edge.set_scale(Vector3(1, 1, (v2.position - v1.position).length()))
	check_face(v1, v2)

func check_face(v1, v2):
	pass
