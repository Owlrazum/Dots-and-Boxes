extends Node

var player_amount = 0

## the public "constant" player information:
var player_names = []
var descriptions = []
var ids = []

var local_player_index

func _ready():
	player_names.resize(6)
	descriptions.resize(6)
	ids.resize(6)


## should be called only to the server by rpc_id(1, ...)
@rpc("reliable", "any_peer")
func add_player_request(is_local_server = false):
	var id = multiplayer.get_remote_sender_id()
	if is_local_server:
		id = 1
	
	# send to new client existing info
	for order in range(0, player_amount):
		add_player_response.rpc_id(id, order, ids[order])
	set_order.rpc_id(id, player_amount)
	
	# notify all clients of added player
	add_player_response.rpc(player_amount, id)


@rpc("reliable", "call_local")
func add_player_response(order, network_id):
	ids[order] = network_id
	player_amount += 1


@rpc("reliable", "call_local")
func set_order(order):
	local_player_index = order
