extends EnemyState

class_name EnemyChaseState

var target: Player = null

func enter(args = null) -> void:
	assert(args is Player, "Always pass player to EnemyChaseState::enter()")
	target = args
	enemy.nav_agent.target_position = target.position
	enemy.animation_player.play("Walk")

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(delta: float) -> void:
	enemy.animation_player.play("Walk")
	
	if !_reached_target():
		var next_position: Vector3 = enemy.nav_agent.get_next_path_position()
		if enemy.position.x < next_position.x:
			enemy.scale.x = abs(enemy.scale.x)
		else:
			enemy.scale.x = -1 * abs(enemy.scale.x)
		
		enemy.animation_player.play("Walk") 
		enemy.global_position = enemy.global_position.move_toward(
			next_position, 
			delta * enemy.movement_speed
		)
	else:
		if _get_distance(enemy.global_position, enemy.target.global_position) < 0.85:
			if randi() % 20 == 0:
				enemy.state_machine.change_state(enemy.state_machine.current_state, "Attack")
			return
		else:
			enemy.nav_agent.target_position = enemy.target.global_position
	
	if enemy is Wolf:
		if enemy.timer > enemy.knife_interval:
			enemy.timer = 0
			var knife: Projectile = ProjectileFactory.create_instance(
				"rose",
				enemy,
				25.0,
				target
			)
			enemy.get_parent().add_child(enemy.active_projectile)
	
		if enemy.active_projectile == null:
			enemy.timer += 1

func _reached_target() -> bool:
	return abs(enemy.nav_agent.target_position.x - enemy.global_position.x) < 0.75 and \
		abs(enemy.nav_agent.target_position.z - enemy.global_position.z) < 0.75 

func _get_distance(pos1: Vector3, pos2: Vector3) -> float:
	return sqrt(
		pow(pos1.x - pos2.x, 2) +
		pow(pos1.y - pos2.y, 2) +
		pow(pos1.z - pos2.z, 2)
	)
