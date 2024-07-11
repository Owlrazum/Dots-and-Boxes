extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.reset();
	$Label.text = Global.winner + " has won";
	$Label.modulate = Global.winner_color;
	$Label2.text = str(Global.winner_score);


func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/sort.tscn");


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit();
