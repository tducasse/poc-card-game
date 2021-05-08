extends Node2D


onready var port = $port
onready var ip = $ip
onready var players = $players
onready var start = $start
onready var host = $host
onready var join = $join
onready var connection_status = $connection_status
onready var game = preload("res://GameBoard.tscn")

var my_id = 0


func _ready():
	var _pc_status = get_tree().connect("network_peer_connected", self, "_player_connected")
	var _pd_status = get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	var _js_status = get_tree().connect("connected_to_server", self, "_join_succeed")
	var _jf_status = get_tree().connect("connection_failed", self, "_join_failed")


# Client and Host method
func _player_connected(_other_id):
	update_players()
	if (my_id == 1):
		start.visible = true


# Client and Host method
func _player_disconnected(_other_id):
	update_players()
	if (my_id == 1):
		start.visible = false


func _join_succeed():
	update_players()
	hide_join_host_buttons()
	connection_status.text = "Success"


func _join_failed():
	players.text = "Players :"
	join.visible = true
	host.visible = true
	connection_status.text = "Failure"


func _on_host_pressed():
	assert(port.text.is_valid_integer())
	var peer = NetworkedMultiplayerENet.new()
	var server_status = peer.create_server(int(port.text), 1)
	if (server_status == 0):
		get_tree().network_peer = peer
		my_id = get_tree().get_network_unique_id()
		update_players()
		hide_join_host_buttons()
		connection_status.text = "Success"
	else:
		peer.close_connection()
		connection_status.text = "Failure"


func _on_join_pressed():
	assert(ip.text.is_valid_ip_address())
	assert(port.text.is_valid_integer())
	var peer = NetworkedMultiplayerENet.new()
	var client_status = peer.create_client(ip.text, int(port.text))
	if (client_status == 0):
		get_tree().network_peer = peer
		my_id = get_tree().get_network_unique_id()
		hide_join_host_buttons()
		connection_status.text = "Connecting..."
	else:
		peer.close_connection()
		connection_status.text = "Failure"


func _on_start_pressed():
	rpc("goto_game")


func update_players():
	var players_text = " Players :\n"
	var players_id = get_tree().get_network_connected_peers()
	players_id.append(my_id)
	for id in players_id:
		players_text += "\t Player%d\n" % [id]
	players.text = players_text


func hide_join_host_buttons() :
	join.visible = false
	host.visible = false


remotesync func goto_game():
	var game_instance = game.instance()
	
	var players_node = Node2D.new()
	players_node.set_name("Players")
	game_instance.add_child(players_node)
	
	var players_id = get_tree().get_network_connected_peers()
	players_id.append(my_id)
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
