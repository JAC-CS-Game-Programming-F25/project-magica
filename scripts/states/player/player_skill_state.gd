extends PlayerState

class_name PlayerSkillState

func enter(args = null) -> void:
	if player is Weyland:
		player.take_internal_damage(5.0)
		player.is_guarding = true
		player.parry_elapsed = 0

func exit() -> void:
	if player is Weyland:
		player.is_guarding = false

func process(_delta: float) -> void:
	player.animation_player.play("Skill")

func physics_process(delta: float) -> void:
	player.use_skill()
