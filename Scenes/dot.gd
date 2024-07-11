extends TextureButton

var ready_to_link = false;
var selected = false;
var linking = false;
var fully_linked = false;
var linked = false;
var point_already_exist = false;

var linked_points_pos : Array = [];
var linked_points : Array = [];
var linked_point = null;
var line = null;

var downRightCorner : int = 0;
var downLeftCorner : int = 0;
var upRightCorner : int = 0;
var upLeftCorner : int = 0;

var global_position_ : Vector2;
var grid_pos : Vector2;

func _ready():
	global_position_ = $MouseDetector.global_position;

func _process(delta):
	global_position_ = $MouseDetector.global_position;
	if Input.is_action_just_pressed("ui_accept"):
		for i in linked_points_pos.size():
			print(linked_points_pos[i].grid_pos);
	if selected:
		if linking && line != null:
			line.points[1] = lerp(line.points[1], get_global_mouse_position() - line.global_position, 0.2);
	pass


func _on_mouse_detector_area_entered(area):
	if area.is_in_group("Mouse") and Global.linking:
		if ((Global.point_selected != null) and Global.point_selected != self):
			ready_to_link = true;
			linked_point = Global.point_selected;


func _on_vertex_pressed():
	if not fully_linked:
		if not ready_to_link:
			selected = not selected;
			if selected:
				Global.linking = true;
				Global.point_selected = self;
				linking = true;
				line = Line2D.new();
				self.add_child(line, false);
				line.z_index = -1;
				#x= line.get_index();
				line.add_point(global_position_ - line.global_position);
				line.add_point(get_global_mouse_position());
				if modulate == Color.WHITE:
					modulate = Global.Current_Player;
			else:
				Global.point_selected = null;
				linking = false;
				Global.linking = false;
				self.remove_child(line);
				if not linked:
					modulate = Color(1,1,1);
		else:
			if (linked_point.grid_pos == grid_pos + Vector2(1,0) or linked_point.grid_pos == grid_pos + Vector2(-1,0) or linked_point.grid_pos == grid_pos + Vector2(0,1) or linked_point.grid_pos == grid_pos + Vector2(0,-1)):
				if linked_points.size() < 4:
					selected = false;
					linking = false;
					Global.linking = false;
					ready_to_link = false;
					linked_point.selected = false;
					linked_point.linking = false;
					linked_point.linked = true;
					linked_point.ready_to_link = false;
					linked_point.get_child(Global.line_index).points[1] = global_position_ - linked_point.get_child(1).global_position;
					for i in linked_points_pos.size():
						if linked_point.grid_pos == linked_points_pos[i]:
							point_already_exist = true;
						else:
							point_already_exist = false;
					if not point_already_exist:
						linked_points_pos.append(linked_point.grid_pos);
						linked_point.linked_points_pos.append(grid_pos);
						linked_points.append(linked_point);
						linked_point.linked_points.append(self);
					if not linked:
						modulate = Global.Current_Player;
					linked = true;
					
					check_boxes();
					Global.point_selected = null;
					linked_point = null;

func check_boxes():
	for i in linked_points.size():
		print("For point "+str(linked_points[i].grid_pos));
		for j in linked_points[i].linked_points_pos.size():
			print("     For point "+str(linked_points[i].linked_points_pos[j]));
			if (grid_pos+Vector2(1,1) == linked_points[i].linked_points_pos[j]):
				if downRightCorner < 1:
					downRightCorner += 1;
				else:
					Global.Boxes_pos.append(grid_pos);
					var c = Global.current;
					if c == 0:
						c = Global.Players.size();
					Global.Scores[c-1] += 1;
			elif (grid_pos+Vector2(-1,-1) == linked_points[i].linked_points_pos[j]):
				if upLeftCorner < 1:
					upLeftCorner += 1;
				else:
					Global.Boxes_pos.append(grid_pos+Vector2(-1,-1));
					var c = Global.current;
					if c == 0:
						c = Global.Players.size();
					Global.Scores[c-1] += 1;
			elif (grid_pos+Vector2(-1,1) == linked_points[i].linked_points_pos[j]):
				if downLeftCorner < 1:
					downLeftCorner += 1;
				else:
					Global.Boxes_pos.append(grid_pos+Vector2(-1,0));
					var c = Global.current;
					if c == 0:
						c = Global.Players.size();
					Global.Scores[c-1] += 1;
			elif (grid_pos+Vector2(1,-1) == linked_points[i].linked_points_pos[j]):
				if upRightCorner < 1:
					upRightCorner += 1;
				else:
					Global.Boxes_pos.append(grid_pos+Vector2(0,-1));
					var c = Global.current;
					if c == 0:
						c = Global.Players.size();
					Global.Scores[c-1] += 1;
	
	Global.current += 1;
