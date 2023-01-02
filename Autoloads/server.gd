extends Node2D

@onready var main = get_tree().get_root().get_node("Main")
signal player_is_ready

@rpc
func kick(player_id):
	rpc_id(player_id,"kick")

@rpc(any_peer)
func request_color_change(target_id, requester_id, color):
	rpc_id(target_id,"get_color_change",target_id, requester_id, color)
	if color == Color.RED:
		await get_tree().create_timer(.5).timeout
		rpc_id(target_id,"get_color_change",target_id, requester_id, Color.WHITE)
	
@rpc
func get_color_change(target_id, requester_id, color):
	pass

@rpc(any_peer)
func get_inputs(sending_id, event):
	main.get_node(str(sending_id)).inputs(event)

@rpc(any_peer, unreliable)
func get_movement(requester,movement_vector):
	main.get_node(str(requester)).set_motion(movement_vector)

@rpc(unreliable)
func update_position(target_id,client_position):
	rpc_id(target_id.to_int(),"update_position_client",target_id,client_position)

@rpc
func update_position_client(target_id, client_position):
	pass

@rpc
func update_GUI(target_id, health_percent, ki_percent):
	rpc_id(target_id, "update_GUI_client", target_id, health_percent,ki_percent)

@rpc
func update_GUI_client(target_id, health_percent, ki_percent):
	pass

@rpc(any_peer)
func client_ready(client_id):
	connect("player_is_ready",main.get_node(str(client_id)).set_client_ready)
	emit_signal("player_is_ready")
