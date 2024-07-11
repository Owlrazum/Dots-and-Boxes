extends Node2D

var dot = preload("res://Scenes/dot.tscn");
var box = preload("res://Scenes/Box.tscn");
var dots = Global.table_size;
var spawning = false;

func _ready():
	spawning = true;
	$DotsContainer.columns = dots;
	$BoxesContainer.columns = dots;

func _process(delta):
	$Label.text = Global.PlayersColors[Global.current] + " turn";
	$Label.modulate = Global.Current_Player;
	if spawning:
		for i in dots*dots:
			Global.create_dots($DotsContainer, dot);
		for i in dots*dots:
			Global.create_dots($BoxesContainer, box);
		spawning = false;
	
	if Global.end_game:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn");
