extends Area3D

class_name Projectile

@export var hitbox: CollisionShape3D
@export var sprite: AnimatedSprite3D

@export var movement_speed: float = 3

var origin: Entity
var target_position: Vector3 = Vector3(INF, INF, INF)
var previous_position: Vector3
var damage: float

var is_friendly: bool

func _ready() -> void:
	sprite.play("Appear")

func _physics_process(delta: float) -> void:
	if sprite.animation == "Idle" and previous_position == global_position:
		queue_free()
	previous_position = global_position

func _on_animated_sprite_3d_animation_finished() -> void:
	if sprite.animation != "Appear":
		return
	
	sprite.play("Idle")
	var game: Game = get_tree().get_first_node_in_group("Game") as Game
	
	for child: Node in game.get_children():
		if !is_friendly and child is not Player or is_friendly and child is not Enemy:
			continue
		
		previous_position = global_position
		target_position = (child as Entity).collision_shape.global_position
		var tween: Tween = get_tree().create_tween()
		var distance: float = sqrt(
			abs(target_position.x - global_position.x) +
			abs(target_position.y - global_position.y) +
			abs(target_position.z - global_position.z)
		)
		tween.tween_property(self, "global_position", target_position, distance / movement_speed)
		
		scale.x = -abs(scale.x) if _should_flip() else abs(scale.x)
		return

func _on_body_entered(body: Node3D) -> void:
	if sprite.animation != "Idle":
		return
	
	if body == origin:
		return
	
	if !is_friendly and body is Player:
		(body as Entity).take_damage(damage, self)
		queue_free()
	elif is_friendly and body is Enemy:
		(body as Entity).take_damage(damage, self)
		queue_free()

func _should_flip() -> bool:
	return global_position.x > target_position.x
