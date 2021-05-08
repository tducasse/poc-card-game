extends Node2D


onready var port = $port
onready var ip = $ip
onready var players = $players
onready var start = $start
onready var host = $host
onready var join = $join
onready var connection_status = $connection_status
onready var game = preload("res://GameBoard.tscn")

var players_id = {}
var my_id = 0


func _ready():
	var _signal = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _signal2 = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")


# Client and Host method
func _player_connected(other_id):
	players_id[other_id] = other_id
	update_players()
	if (my_id == 1):
		start.visible = true


# Client and Host method
func _player_disconnected(other_id):
	players_id.erase(other_id)
	update_players()
	if (my_id == 1):
		start.visible = false


func _on_host_pressed():
	assert(port.text.is_valid_integer())
	var peer = NetworkedMultiplayerENet.new()
	var server_status = peer.create_server(int(port.text), 2)
	control_status(server_status, peer)


func _on_join_pressed():
	assert(ip.text.is_valid_ip_address())
	assert(port.text.is_valid_integer())
	var peer = NetworkedMultiplayerENet.new()
	var client_status = peer.create_client(ip.text, int(port.text))
	control_status(client_status, peer)


func _on_start_pressed():
	rpc("goto_game")


func control_status(status, peer):
	if (status == 0):
		get_tree().network_peer = peer
		my_id = get_tree().get_network_unique_id()
		players_id[my_id] = my_id
		update_players()
		host.visible = false
		join.visible = false
		connection_status.text = "Success"
	else:
		peer.close_connection()
		connection_status.text = "Failure"


func update_players():
	var players_text = " Players :\n"
	for id in players_id:
		players_text += "\t Player%d\n" % [id]
	players.text = players_text


remotesync func goto_game():
	var game_instance = game.instance()
	
	var players_node = Node2D.new()
	players_node.set_name("Players")
	game_instance.add_child(players_node)
	
	for id in players_id:
		var player = Node2D.new()
		player.set_name(str(id))
		player.set_network_master(id)
		players_node.add_child(player)
	
	var root_node = get_tree().get_root()
	var lobby_node = get_node("/root/Lobby")
	root_node.remove_child(lobby_node)
	lobby_node.call_deferred("free")
	root_node.add_child(game_instance)
