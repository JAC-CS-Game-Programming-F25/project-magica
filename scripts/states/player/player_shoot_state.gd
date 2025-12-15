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
	var game: Game = get_tree().get_first_node_in_group("Game") as Game
	
	if target == null:
		for child in game.get_children():
			if child is Enemy:
				target = child
				player.scale.x = -abs(player.scale.x) if _should_flip() else abs(player.scale.x)
	
	var arrow: Projectile = load('res://scenes/objects/sal_arrow.tscn').instantiate()
	var pos: Vector3 = player.collision_shape.global_position
	arrow.position = Vector3(pos.x, pos.y + 0.25, pos.z)
	arrow.origin = player
	arrow.is_friendly = true
	arrow.scale.x = arrow.scale.x if player.scale.x > 0 else -arrow.scale.x
	arrow.damage = (player as Sal).arrow_damage
	player.active_projectile = arrow
	player.get_parent().add_child(arrow)
	player.state_machine.change_state(player.state_machine.current_state, "Idle")

func _should_flip() -> bool:
	return target.global_position.x < player.global_position.x
