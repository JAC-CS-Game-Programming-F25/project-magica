extends PlayerState

class_name PlayerSkillState

func enter(args = null) -> void:
	player.take_internal_damage(5.0)
	player.is_guarding = true

func exit() -> void:
	player.is_guarding = false

func process(_delta: float) -> void:
	player.animation_player.play("Guard")

func physics_process(delta: float) -> void:
	player.use_skill()
