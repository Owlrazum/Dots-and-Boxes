extends Control

var grid_pos : Vector2;

var found = false;
var got_color = false;
var color : Color;
var alpha : float;

func _ready():
	alpha = 0.0;
	color = Color(1,1,1,0);

func _process(delta):
	if grid_pos.x == Global.table_size-1 or grid_pos.y == Global.table_size-1:
		modulate.a = 0;
	
	if found and not got_color:
		get_color();
	
	modulate = color;
	modulate.a = lerp(modulate.a, alpha, 0.2);
	
	for i in Global.Boxes_pos.size():
		if Global.Boxes_pos[i] == grid_pos:
			found = true;
			alpha = 0.3;

func get_color():
	color = Global.Players[Global.current-1];
	found = false;
	got_color = true;
