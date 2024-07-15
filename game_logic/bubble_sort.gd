class_name BubbleSort extends Node

signal completed(bs)

@export var swap_duration = 0.3
@export var cards_amount = 15
@export var cards_gap = 10
@export var card_size = 64
@export var card_max_value = 20

@export var default_color: Color
@export var element_cards: Array[ColorRect] = []

var element_scene = preload("res://game_logic/element.tscn")
var current_tween
var goback = false

func _ready():
	var first = element_scene.instantiate() as ColorRect
	add_child(first)
	first.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	var value = randi_range(1, card_max_value)
	first.get_child(0).text = str(value)
	element_cards.append(first)
	var pos = first.position - cards_amount / 2 * (cards_gap + card_size) * Vector2(0, 1)
	first.position = pos
	for i in range(cards_amount - 1):
		pos.y += cards_gap + card_size
		value = randi_range(1, card_max_value)
		element_cards.append(add_element(pos, value))

func add_element(pos, value):
	var e = element_scene.instantiate() as ColorRect
	add_child(e)
	e.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	e.get_child(0).text = str(value)
	e.position = pos
	return e

func on_StartSort_pressed():
	var n = element_cards.size()
	var swapped = true
	while swapped:
		swapped = false
		for i in range(1, n):
			var v1 = int(element_cards[i - 1].get_child(0).text)
			if v1 > int(element_cards[i].get_child(0).text):
				await swap(i - 1, i)
				if goback:
					return
				swapped = true
		n -= 1

func swap(e1, e2):
	var c1 = element_cards[e1]
	var c2 = element_cards[e2]
	
	current_tween = get_tree().create_tween()
	current_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true)
	current_tween.tween_callback(func(): 
		c1.color = Color.ORANGE_RED
		c2.color = Color.ORANGE_RED)
	current_tween.chain().tween_property(c1, "position", c2.position, swap_duration)
	current_tween.tween_property(c2, "position", c1.position, swap_duration)
	current_tween.chain().tween_callback(func(): 
		c1.color = default_color
		c2.color = default_color)
	
	var tc = element_cards[e1]
	element_cards[e1] = element_cards[e2]
	element_cards[e2] = tc
	
	return current_tween.finished

func on_GoBack_pressed():
	if current_tween:
		current_tween.kill()
	goback = true
	completed.emit(self)
