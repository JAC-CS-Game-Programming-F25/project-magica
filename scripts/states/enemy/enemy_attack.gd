extends EnemyState

class_name EnemyAttackingState

var timer: int = 0
var pause_duration: int = 10
var reset: bool = false

signal attack_anim_done

func _ready() -> void:
	attack_anim_done.connect(_on_attack_anim_done)

func enter(args = null) -> void:
	enemy.animation_player.play(EntityStates.attack)

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	if reset:
		if timer > pause_duration:
			enemy.change_state(EntityStates.attack)
			timer = 0
		
		timer += 1

func _on_attack_anim_done() -> void:
	if enemy.target == null:
		enemy.state_machine.change_state(enemy.state_machine.current_state, EntityStates.idle)
	elif enemy._get_distance(enemy.target.position, enemy.global_position) > 0.75:
		enemy.state_machine.change_state(enemy.state_machine.current_state, EntityStates.chase, enemy.target)
	else:
		pause_duration = randi() % 10
		timer = 0
		reset = true
