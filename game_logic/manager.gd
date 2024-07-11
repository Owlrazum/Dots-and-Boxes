extends Node


#Note: When exporting to Android, make sure to enable the INTERNET permission in the Android export preset before exporting the project or using one-click deploy. Otherwise, network communication of any kind will be blocked by Android.


@export var selection: Selection

@export var dims: Vector2i = Vector2i(4, 4)
@export var gap: float = 100
@export var vertex_size: float = 32

@export var vertex_scene = preload("res://game_logic/vertex.tscn")
@export var edge_scene = preload("res://game_logic/edge.tscn")
@export var face_scene = preload("res://game_logic/face.tscn")

@export var vertices_parent: Node
@export var edges_parent: Node
@export var faces_parent: Node

var player_turn # 0 or 1
var made_face

var selected_vertex: Vertex
var faces = [] # faces, each with number of edges 0..4
var edges = [] # per vertex the array of 4 booleans denoting edge

var p1_faces_amount = 0
var p2_faces_amount = 0

enum {
	U, #up
	R, #right
	D, #down
	L  #left
}

@rpc("reliable", "any_peer", "call_local")
func make_turn(v1pos, v2pos, player):
	make_edge(v1pos, v2pos, player)
	if not made_face and PlayerList.player_amount > 1: 
		player_turn = 0 if player_turn == 1 else 1
		selection.can_select = PlayerList.local_player_index == player_turn
	made_face = false

func _ready():
	var delta = (vertex_size + gap) * Vector3(1, 0, 1)
	var start_delta = -delta;
	if dims.y % 2 == 0:
		start_delta.x /= 2;
		start_delta.z /= 2;

	var t = -(dims / 2.0 - Vector2(1, 1))
	var start_pos = Vector3(t.x * delta.x, 0, t.y * delta.z) + start_delta
	var pos = start_pos;
	
	for r in dims.x:
		for c in dims.y:
			var vertex = vertex_scene.instantiate() as Vertex
			vertices_parent.add_child(vertex)
			vertex.position = pos
			vertex.pos = Vector2i(c, r)
			vertex.vertex_pressed.connect(on_vertex_pressed)
			vertex.material_override = vertex.material_override.duplicate()

			pos.x += delta.x
		pos.x = start_pos.x
		pos.z += delta.z
	
	for r in dims.x:
		for c in dims.y:
			edges.append([0, 0, 0, 0])
			if c != dims.y - 1 or r != dims.x: 
				faces.append(0)
	
	player_turn = 0
	made_face = false
	selection.can_select = PlayerList.local_player_index == player_turn

func on_vertex_pressed(vertex):
	if selected_vertex:
		if is_adjacent(vertex, selected_vertex):
			make_turn.rpc(selected_vertex.pos, vertex.pos, PlayerList.local_player_index)
		
		selected_vertex.default()
		default_adjacent(selected_vertex)
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
	if vertex.pos.x > 0:          vertices_parent.get_child(xytox(vertex.pos.x - 1, vertex.pos.y, dims.x)).highlight()
	if vertex.pos.x < dims.x - 1: vertices_parent.get_child(xytox(vertex.pos.x + 1, vertex.pos.y, dims.x)).highlight()
	if vertex.pos.y > 0:          vertices_parent.get_child(xytox(vertex.pos.x, vertex.pos.y - 1, dims.x)).highlight()
	if vertex.pos.y < dims.x - 1: vertices_parent.get_child(xytox(vertex.pos.x, vertex.pos.y + 1, dims.x)).highlight()

func default_adjacent(vertex):
	if vertex.pos.x > 0:          vertices_parent.get_child(xytox(vertex.pos.x - 1, vertex.pos.y, dims.x)).default()
	if vertex.pos.x < dims.x - 1: vertices_parent.get_child(xytox(vertex.pos.x + 1, vertex.pos.y, dims.x)).default()
	if vertex.pos.y > 0:          vertices_parent.get_child(xytox(vertex.pos.x, vertex.pos.y - 1, dims.x)).default()
	if vertex.pos.y < dims.x - 1: vertices_parent.get_child(xytox(vertex.pos.x, vertex.pos.y + 1, dims.x)).default()
	
func xytox(x, y, d):
	return y * d + x

func xtoxy(x, d):
	return Vector2i(x % d, x / d)

func diftodir(dif):
	match dif:
		Vector2i( 0, -1):  return U
		Vector2i( 1,  0):  return R
		Vector2i( 0,  1): return D
		Vector2i(-1,  0): return L

func edgetofaces(v, d):
	var face_index = Vector2i(-1, -1)
	match d:
		U: 
			if v.pos.x > 0 and v.pos.y > 0:
				face_index.x = xytox(v.pos.x - 1, v.pos.y - 1, dims.x - 1)
			if v.pos.y > 0 and v.pos.x < dims.x - 1:
				face_index.y = xytox(v.pos.x, v.pos.y - 1, dims.x - 1)
		R: 
			if v.pos.y > 0 and v.pos.x < dims.x - 1 :
				face_index.x = xytox(v.pos.x, v.pos.y - 1, dims.x - 1)     
			if v.pos.x < dims.x - 1 and v.pos.y < dims.y - 1:
				face_index.y = xytox(v.pos.x, v.pos.y, dims.x - 1)
		D: 
			if v.pos.x > 0 and v.pos.y < dims.y - 1 :
				face_index.x = xytox(v.pos.x - 1, v.pos.y, dims.x - 1)     
			if v.pos.x < dims.x - 1 and v.pos.y < dims.y - 1:
				face_index.y = xytox(v.pos.x, v.pos.y, dims.x - 1)
		L: 
			if v.pos.x > 0 and v.pos.y > 0:
				face_index.x = xytox(v.pos.x - 1, v.pos.y - 1, dims.x - 1) 
			if v.pos.x > 0 and v.pos.y < dims.y - 1:
				face_index.y = xytox(v.pos.x - 1, v.pos.y, dims.x - 1)
	return face_index

func make_edge(v1pos, v2pos, player):
	var v1 = vertices_parent.get_child(xytox(v1pos.x, v1pos.y, dims.x))
	var v2 = vertices_parent.get_child(xytox(v2pos.x, v2pos.y, dims.x))
	var d1 = diftodir(v2.pos - v1.pos)
	if edges[xytox(v1.pos.x, v1.pos.y, dims.x)][d1]:
		return
	var d2 = diftodir(v1.pos - v2.pos)
	edges[xytox(v1.pos.x, v1.pos.y, dims.x)][d1] = 1
	edges[xytox(v2.pos.x, v2.pos.y, dims.x)][d2] = 1
	
	var face_index = edgetofaces(v1, d1)
	#print("%s %s %s %s " % [d1, v1.pos, v2.pos, face_index])
	if face_index.x >= 0: 
		faces[face_index.x] += 1
		#print("face %s incremented. its value %s" % [face_index.x, faces[face_index.x]])
		if faces[face_index.x] == 4:
			make_face(face_index.x, player)
	if face_index.y >= 0: 
		faces[face_index.y] += 1
		#print("face %s incremented. its value %s" % [face_index.y, faces[face_index.y]])
		if faces[face_index.y] == 4:
			make_face(face_index.y, player)
	
	var p = v1.position - v2.position
	var edge = edge_scene.instantiate() as Edge
	edges_parent.add_child(edge)
	edge.position = v2.position
	edge.look_at_from_position(v1.position, v2.position)
	edge.set_scale(Vector3(1, 1, (v2.position - v1.position).length()))

func make_face(face_index, player):
	var face = face_scene.instantiate() as Face
	faces_parent.add_child(face)
	var fi = xtoxy(face_index, dims.x - 1)
	face.position = vertices_parent.get_child(xytox(fi.x, fi.y, dims.x)).position + Vector3.UP * 0.5
	face.material_override = face.material_override.duplicate()
	if player == 0: face.p1()
	else: face.p2()
	made_face = true
