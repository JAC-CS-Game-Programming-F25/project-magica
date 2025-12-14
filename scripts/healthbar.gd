extends Control

class_name HealthBar

@export var player: Weyland

@onready var health: ColorRect = $Health

var max_width: float = 380.0

func _physics_process(delta: float) -> void:
	if player.health < player.internal_damage:
		var tween: Tween = get_tree().create_tween()
		var duration: float = delta
		var width: float = max_width * player.health / player.max_health
	
		tween.tween_property($Health, "size", Vector2(width, 20.0), duration)
	elif player.health == player.internal_damage:
		$Health.size.x = $InternalDamage.size.x

func take_damage() -> void:
	var final_width: float = max_width * player.health / player.max_health
	_tween_health(final_width)
	$InternalDamage.size.x = final_width

func take_internal_damage() -> void:
	var final_width: float = max_width * player.health / player.max_health
	_tween_health(final_width)

func _tween_health(width: float) -> void:
	var tween: Tween = get_tree().create_tween()
	var duration: float = player.flinch_duration_frames / 60.0
	
	tween.tween_property($Health, "size", Vector2(width, 20.0), duration)
