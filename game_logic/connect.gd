extends Control

const DEF_PORT = 8080
const PROTO_NAME = "ludus"

var peer = WebSocketMultiplayerPeer.new()
var hosted: bool

@onready var host = $Control/HBox/Host
@onready var client = $Control/HBox/Client
@onready var start = $Control/HBox/Start

@onready var host_ip = $Control/HBox/Label as Label
@onready var client_connect_ip = $Control/HBox/Client/LineEdit as LineEdit

func _init():
	peer.supported_protocols = [PROTO_NAME]


func _ready():
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.server_disconnected.connect(close_network)
	multiplayer.connection_failed.connect(close_network)
	
	client_connect_ip.text = '192.168.'


func on_connected_to_server():
	PlayerList.add_player_request.rpc_id(1, {})


func close_network():
	multiplayer.multiplayer_peer = null
	peer.close()


func on_Host_pressed():
	if hosted:
		push_error("double host error")

	hosted = true
	multiplayer.multiplayer_peer = null
	peer.create_server(DEF_PORT)
	multiplayer.multiplayer_peer = peer
	
	PlayerList.add_player_request(true)

	host.visible = false
	client.visible = false
	start.visible = true
	
	var ips = IP.get_local_addresses()
	host_ip.text = "the host ip is "
	for s in ips:
		if s.contains("192"):
			host_ip.text += s

func on_Client_pressed():
	multiplayer.multiplayer_peer = null
	var error
	if client_connect_ip.text.length() > 4:
		var url = "ws://%s:%s" % [client_connect_ip.text, str(DEF_PORT)]
		print(url)
		error = peer.create_client(url)
	else:
		error = peer.create_client("ws://localhost:" + str(DEF_PORT))
	assert(error == OK)
	multiplayer.multiplayer_peer = peer
	
	host.visible = false
	client.visible = false


func on_Start_pressed():
	goto_game_scene.rpc()


@rpc("reliable", "call_local")
func goto_game_scene():
	SceneSwitcher.call_deferred(&"load_game_deferred")
