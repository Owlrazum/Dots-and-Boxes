extends Node

var amount = 0

## the public "constant" player information:
var player_names = []
var descriptions = []
var ids = []

var local_order

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
	for order in range(0, amount):
		add_player_response.rpc_id(id, order, ids[order])
	set_order.rpc_id(id, amount)
	
	# notify all clients of added player
	add_player_response.rpc(amount, id)


@rpc("reliable", "call_local")
func add_player_response(order, network_id):
	ids[order] = network_id
	amount += 1


@rpc("reliable", "call_local")
func set_order(order):
	local_order = order
