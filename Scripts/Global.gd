extends Node

var Players : Array = [Color(1, 0.22, 0.22), Color(0.22, 0.285, 1), Color(0.948, 1, 0.22), Color(0.22, 1, 0.272), Color(1, 0.649, 0.22)];
var PlayersColors : Array = ["Red", "Blue", "Yellow", "Green", "Orange"];
var Scores : Array = [0,0,0,0,0];
var Boxes_pos : Array = [];

var table_size = 5;
var Current_Player : Color;
var winner_color : Color;

var mouse_pos : Vector2;

var end_game = false;
var linking = false;

var point_selected = null;

var winner : String;

var winner_score = 0;
var Red_Score = 0;
var Blue_Score = 0;
var Yellow_Score = 0;
var Green_Score = 0;
var Orange_Score = 0;

var line_index = 0;
var current = 0;

func _process(_delta):
	Red_Score = Scores[0];
	Blue_Score = Scores[1];
	Yellow_Score = Scores[2];
	Green_Score = Scores[3];
	Orange_Score = Scores[4];
	
	winner_score = max(Red_Score, Blue_Score, Yellow_Score, Green_Score, Orange_Score);
	winner = PlayersColors[current-1];
	winner_color = Players[current-1];
	
	if (current == Players.size()):
		current = 0;
	Current_Player = Players[current];

func create_dots(parent, dot):
	var dot_inst = dot.instantiate();
	parent.add_child(dot_inst);

func reset():
	Scores = [0,0,0,0,0];
	winner_color = Color.WHITE;
	winner = "";
	current = 0;
	line_index = 0;
	point_selected = null;
	linking = false;
	end_game = false;
