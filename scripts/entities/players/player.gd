extends Entity

class_name Player

@export var health_bar: HealthBar
@export var heal_timer: float = 1.0
@export var heal_percentage: float = 20.0

var internal_damage: float
var time_since_damage: float

var target: Enemy = null

signal game_status

func set_movement_target(movement_target: Vector3) -> void:
	var current_state: PlayerState = state_machine.current_state
	if !(current_state is PlayerIdleState or current_state is PlayerWalkingState):
		return
	
	state_machine.change_state(state_machine.current_state, "walking", movement_target)

func take_damage(damage: float, _damager: Node3D = null) -> void:
	super.take_damage(damage, _damager)
	
	time_since_damage = 0
	internal_damage = health
	health_bar.take_damage()
	state_machine.change_state(state_machine.current_state, "Flinch")

func take_internal_damage(damage: float) -> void:
	health -= damage
	time_since_damage = 0
	health_bar.take_internal_damage()

func use_skill() -> void:
	pass

func _on_game_status_change(is_started: bool) -> void:
	if is_started:
		health_bar.show()
	else:
		health_bar.hide()
