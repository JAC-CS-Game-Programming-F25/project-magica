extends PlayerState

class_name PlayerIdleState

func enter(args = null) -> void:
	pass

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	player.animation_player.play("Idle")
