extends Area3D

class_name Projectile

@export var hitbox: CollisionShape3D
@export var sprite: AnimatedSprite3D

@export var movement_speed: float = 3

var origin: Entity
var target_position: Vector3 = Vector3(INF, INF, INF)
var previous_position

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
		if child is not Player:
			continue
		
		previous_position = global_position
		target_position = (child as Player).collision_shape.global_position
		var tween: Tween = get_tree().create_tween()
		var distance: float = sqrt(
			abs(target_position.x - global_position.x) +
			abs(target_position.y - global_position.y) +
			abs(target_position.z - global_position.z)
		)
		tween.tween_property(self, "global_position", target_position, distance / movement_speed)

func _on_body_entered(body: Node3D) -> void:
	if body == origin:
		return
	
	if body is Player:
		(body as Player).take_damage(25.0, self)
		queue_free()
