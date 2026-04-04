extends Node3D

var peer = NodeTunnelPeer.new()
@export var player_scene: PackedScene

const PORT = 9998

func _ready() -> void:
	multiplayer.multiplayer_peer = peer
	peer.connect_to_relay("relay.nodetunnel.io",9998)
	
	await peer.relay_connected
	
	%OnlineID.text = peer.online_id
func _on_host_pressed() -> void:
	peer.host()
	
	await peer.hosting
	
	DisplayServer.clipboard_set(peer.online_id)
	
	multiplayer.peer_connected.connect(add_player)	
	add_player()
	$CanvasLayer.hide()

func _on_join_pressed() -> void:
	peer.join(%HostOnlineID.text)
	
	await peer.joined
	
	$CanvasLayer.hide()

func _exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)
	
func del_player(id):
	rpc("_del_player",id)
	
@rpc("any_peer","call_local")
func _del_player(id):
	get_node(str(id)).queue_free()


func _on_online_id_pressed() -> void:
	DisplayServer.clipboard_set(%OnlineID.text)
	$CanvasLayer/HBoxContainer/VBoxContainer2/Label.text = "ID copied to clipboard !" 
