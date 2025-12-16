extends EnemyState

class_name EnemyIdleState

func enter(args = null) -> void:
	enemy.animation_player.play(EntityStates.idle)

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	enemy.animation_player.play(EntityStates.idle)
