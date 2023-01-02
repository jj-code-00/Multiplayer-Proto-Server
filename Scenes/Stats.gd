extends Node

var health_percent = 100.0
var ki_percent = 100.0
var client_ready_notify
@onready var player_id = str(get_parent().name).to_int()
@onready var player_node = get_tree().get_root().get_node("Main").get_node(str(player_id))


var stats = {
	"Max Health": 100.0,
	"Current Health": 100.0,
	"Vitality": 5.0,
	"Max Ki": 100.0,
	"Current Ki": 100.0,
	"Spirit": 5.0,
	"Strength": 5.0,
	"Agility": 5.0,
	"Durability": 5.0,
	"Force": 5.0
}

func _process(delta):
	if client_ready_notify && stats.get("Current Health") <= 0:
#		Server.kick(str(get_parent().name).to_int())
		pass

func take_damage(strength, attack_direction):
	stats["Current Health"] = clamp(stats.get("Current Health") - strength,0,stats.get("Max Health"))
	get_parent().velocity = attack_direction * 300
	get_parent().knock_back = true
	get_parent().get_node("Timers/Knock Back").start(.2)
	calc_health_percent()

func _on_player_character_player_ready():
	client_ready_notify = true
	Server.update_GUI(player_id,health_percent,ki_percent)

func calc_health_percent():
	var max_health = stats.get("Max Health")
	var current_health = stats.get("Current Health")
	health_percent = (current_health / max_health) * 100
	if client_ready_notify:
		Server.update_GUI(player_id,health_percent,ki_percent)
