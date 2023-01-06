extends CharacterBody2D

@onready var punch_hurtbox = $"HurtBox/HurtBox Collision Shape"
@onready var main = get_tree().get_root().get_node("Main")
@onready var clock = main.get_node("Game Manager").get_node("Clock")

signal player_ready

@export
var motion = Vector2.ZERO

var facing = Vector2.ZERO
var attacking = false
var client_ready = false
var knock_back = false
var knock_back_vector = Vector2.ZERO
var can_move = true

func set_client_ready():
	client_ready = true
	emit_signal("player_ready")

func _ready():
	facing = motion
	clock.timeout.connect(Callable(self,"second_clock"))

func _process(delta):
	pass

func _physics_process(delta):
	if client_ready:
		if !knock_back && can_move:
			velocity = motion * 250
		move_and_slide()
		Server.update_position(str(name),global_position)

func set_motion(vector):
	motion = vector
	if motion != Vector2.ZERO:
		facing = motion

func inputs(event):
	if client_ready:
		if event == "i_attack" && !attacking:
			# update this with code at home 360 degree cursor and attacking
			match facing:
				Vector2.RIGHT:
					punch_hurtbox.position = Vector2(15,3)
				Vector2.DOWN:
					punch_hurtbox.position = Vector2(0,15)
				Vector2.LEFT:
					punch_hurtbox.position = Vector2(-15,3)
				Vector2.UP:
					punch_hurtbox.position = Vector2(0,-15)
			punch_hurtbox.disabled = false
			$"Timers/Attack CD".start(.2)
			# finish this with health and ki regen
		if event == "i_meditate" && !attacking:
			if can_move:
				can_move = false
				velocity = Vector2.ZERO
				$Stats.meditating = true
			else:
				can_move = true
				$Stats.meditating = false

func _on_hurt_box_body_entered(body):
	if body.is_in_group("players") && body.name != self.name:
		main.get_node(str(str(body.name))).get_node("Stats").take_damage($Stats.stats.get("Strength"), (main.get_node(str(str(body.name))).global_position - global_position).normalized())
		Server.request_color_change(str(body.name).to_int(),str(name).to_int(),Color.RED)

func _on_attack_cd_timeout():
	attacking = false
	punch_hurtbox.disabled = true

func _on_knock_back_timeout():
	knock_back = false

func second_clock():
	pass

