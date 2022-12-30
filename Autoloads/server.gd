extends Node

@onready var main = get_tree().get_root().get_node("Main")

@rpc(any_peer)
func request_color_change(target_id, requester_id, color):
	rpc_id(target_id,"get_color_change",target_id, requester_id, color)
	if color == Color.RED:
		await get_tree().create_timer(.5).timeout
		rpc_id(target_id,"get_color_change",target_id, requester_id, Color.WHITE)
	
@rpc
func get_color_change(target_id, requester_id, color):
	pass
