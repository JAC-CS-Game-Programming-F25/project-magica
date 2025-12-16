extends PlayerState

class_name PlayerFlinchState

@export var flinch_duration: int = 10

var duration: int = 10

func enter(args = null) -> void:
	duration = flinch_duration;
	player.sprite.modulate = Color(1., 0.4, 0.4, 1.)

func exit() -> void:
	player.sprite.modulate = Color(1., 1., 1., 1.)

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	if duration <= 0:
		player.change_state(EntityStates.idle)
	
	player.animation_player.play(EntityStates.flinch)
	duration -= 1
