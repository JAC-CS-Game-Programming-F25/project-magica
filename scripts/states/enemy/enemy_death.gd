extends EnemyState

class_name EnemyDeathState

signal death_anim_done

func _ready() -> void:
	death_anim_done.connect(_on_death_anim_done)

func enter(args = null) -> void:
	enemy.animation_player.play("Die")
	if enemy is Wolf:
		var wolf = enemy as Wolf
		wolf.whip_hitbox.disabled = true
		wolf.whip_hitbox_area.monitoring = false

func exit() -> void:
	call_deferred("queue_free")

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	enemy.animation_player.play("Die")

func _on_death_anim_done() -> void:
	for child in enemy.get_parent().get_children():
		if child == enemy:
			enemy.get_parent().remove_child(enemy)
			exit()
