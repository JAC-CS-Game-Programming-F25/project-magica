extends PlayerState

class_name PlayerParryState

var damager: Node3D
var is_sprite_flipped: bool = false

signal parry_done

func _ready() -> void:
	parry_done.connect(_on_parry_done)

func enter(args = null) -> void:
	assert(args is Node3D, "Pass in damager when changing to parry state")
	
	damager = args
	player.is_successful_parry = true
	player.animation_player.play(EntityStates.parry)
	
	if _should_flip_player():
		player.scale.x *= -1

func exit() -> void:
	player.is_successful_parry = false
	
	if _should_flip_player():
		player.scale.x *= -1

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	player.animation_player.play(EntityStates.parry)

func _should_flip_player() -> bool:
	if damager == null: 
		return false
		
	return damager.global_position.x < player.global_position.x and player.scale.x > 0 \
		or damager.global_position.x > player.global_position.x and player.scale.x < 0

func _on_parry_done() -> void:
	if Input.is_action_pressed("Weyland_Skill"):
		player.state_machine.change_state(player.state_machine.current_state, EntityStates.skill)
	else:
		player.state_machine.change_state(player.state_machine.current_state, EntityStates.idle)
