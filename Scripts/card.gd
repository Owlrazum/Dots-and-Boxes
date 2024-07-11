extends Node2D

var selected = false;
var selectednext = false;
var value : int;

func _ready():
	value = randi_range(1,20);

func _process(delta):
	if selected:
		modulate = lerp(modulate, Color.LIGHT_YELLOW, 0.2);
	elif selectednext:
		modulate = lerp(modulate, Color.LIGHT_BLUE, 0.2);
	else:
		modulate = lerp(modulate, Color.WHITE, 0.2);
	$Label.text = str(value);
