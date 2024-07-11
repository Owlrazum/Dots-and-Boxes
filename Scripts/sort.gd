extends Node2D

var next_scene = load("res://Scenes/table.tscn");

var transition = false;

func _ready():
	$AnimationPlayer.play("slide_up");
	await($AnimationPlayer.animation_finished);
	bubble_sort_cards();

func _process(delta):
	if transition:
		#$AnimationPlayer.play_backwards("slide_up");
		#await($AnimationPlayer.animation_finished);
		get_tree().change_scene_to_file("res://Scenes/table.tscn");

func get_card_value(card : Node2D) -> int:
	return card.value;

func swap_cards(card1, card2):
	var temp_position = card1.global_position
	card1.global_position = card2.global_position;
	card2.global_position = temp_position;

func bubble_sort_cards():
	var cards = $Cards.get_children()
	var n = cards.size()
	var swapped = true
	while swapped:
		swapped = false
		for i in range(n):
			cards[i].selected = true;
			await(get_tree().create_timer(.4).timeout);
			if i<cards.size()-1:
				cards[i+1].selectednext = true;
			if i>0:
				cards[i-1].selected = false;
				cards[i-1].selectednext = false;
			if i<cards.size()-1:
				if get_card_value(cards[i]) > get_card_value(cards[i + 1]):
					await($SwapButton.pressed);
					swap_cards(cards[i], cards[i + 1])
					var temp = cards[i];
					cards[i] = cards[i+1];
					cards[i+1] = temp;
					swapped = true
	
	transition = true;
