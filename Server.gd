extends Node

var multiplayer_peer = ENetMultiplayerPeer.new()

func _on_start_pressed():
	multiplayer_peer.create_server(
		$CenterContainer/Menu/Port.text.to_int(),
		$"CenterContainer/Menu/Max Players".text.to_int()
	)
	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.peer_connected.connect(func(id): add_player_character(id))
	multiplayer_peer.peer_disconnected.connect(func(id): remove_player_character(id))
	$CenterContainer/Menu.visible = false
	
func add_player_character(id):
	print("Player " + str(id) + " Connected!")
	var character = preload("res://Scenes/player_character.tscn").instantiate()
	character.name = str(id)
	character.set_multiplayer_authority(id)
	add_child(character)
	
func remove_player_character(id):
	get_node(str(id)).queue_free()

