extends EnemyState

class_name EnemyAttackingState

var anim_duration: int = 24

signal attack_anim_done

func _ready() -> void:
	attack_anim_done.connect(_on_attack_anim_done)

func enter(args = null) -> void:
	enemy.animation_player.play("Attack")

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	if anim_duration <= 0:
		attack_anim_done.emit()
		anim_duration = 24
	
	anim_duration -= 1

func _on_attack_anim_done() -> void:
	if enemy.target == null:
		enemy.state_machine.change_state(enemy.state_machine.current_state, "Idle")
		return
	
	if enemy._get_distance(enemy.target.position, enemy.global_position) > 0.75:
		enemy.state_machine.change_state(enemy.state_machine.current_state, "Chase", enemy.target)
