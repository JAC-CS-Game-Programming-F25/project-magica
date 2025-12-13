extends PlayerState

class_name PlayerWalkingState

func enter(args = null) -> void:
	assert(
		args != null and args is Vector3, 
		"PlayerWalkingState::enter() requires Vector3 to be passed in."
	)
	player.nav_agent.target_position = args

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(delta: float) -> void:
	if reached_target():
		player.animation_player.play("Idle")
		return
	var next_position: Vector3 = player.nav_agent.get_next_path_position()
	if player.position.x < next_position.x:
		player.sprite.flip_h = false
	else:
		player.sprite.flip_h	= true
		
	player.animation_player.play("Walk") 
	player.global_position = player.global_position.move_toward(
		next_position, 
		delta * player.movement_speed
	)

func reached_target() -> bool:
	return abs(player.position.x - player.nav_agent.target_position.x) < 0.1 and \
		abs(player.position.z - player.nav_agent.target_position.z) < 0.1 
