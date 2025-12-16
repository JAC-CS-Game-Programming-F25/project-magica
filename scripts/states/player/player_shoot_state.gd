extends PlayerState

class_name PlayerShootState

var target: Enemy

signal anim_done

func _ready() -> void:
	anim_done.connect(_on_anim_done)

func enter(args = null) -> void:
	assert(args is Enemy, "Pass in enemy when changing to shooting state")
	player.animation_player.play("Shoot")
	target = args
	player.scale.x = -abs(player.scale.x) if _should_flip() else abs(player.scale.x)

func exit() -> void:
	if player is Sal:
		(player as Sal).timer = 0

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	player.animation_player.play("Shoot")

func _on_anim_done() -> void:
	_shoot_arrow()
	player.state_machine.change_state(player.state_machine.current_state, "Idle")

func _shoot_arrow() -> void:
	(player as Sal).bow_sfx.play()
	var game: Game = get_tree().get_first_node_in_group(GroupNames.game) as Game
	
	if target == null:
		for child in game.get_children(true):
			if child is Enemy:
				target = child
				player.scale.x = -abs(player.scale.x) if _should_flip() else abs(player.scale.x)
	
	var projectile: Projectile = ProjectileFactory.create_instance(
		"arrow",
		player,
		25.0,
		target
	)
	player.get_parent().add_child(projectile)
	player.state_machine.change_state(player.state_machine.current_state, "Idle")

func _should_flip() -> bool:
	return target.global_position.x < player.global_position.x
