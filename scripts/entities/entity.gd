extends CharacterBody3D

class_name Entity

@export var animation_player: AnimationPlayer
@export var collision_shape: CollisionShape3D
@export var nav_agent: NavigationAgent3D
@export var sprite: AnimatedSprite3D
@export var state_machine: StateMachine

@export var movement_speed: float = 1.25
@export var max_health: float
@export var flinch_duration_frames: int = 10

var health: float
var is_dead: bool = false

var active_projectile: Projectile = null

func take_damage(damage: float, _damager: Node3D = null) -> void:
	health -= damage

func attack() -> void:
	pass

func change_state(new_state: String, args = null) -> void:
	state_machine.change_state(state_machine.current_state, new_state, args)

func actor_setup() -> void:
	await get_tree().physics_frame

func set_movement_target(movement_target: Vector3) -> void:
	pass

func set_shader_params() -> void:
	var base_tex_path: String = "shader_parameter/base_texture"
	var current_frame: Texture2D = sprite.sprite_frames.get_frame_texture(
		sprite.animation, 
		sprite.frame
	)
	sprite.material_overlay.set(base_tex_path, current_frame)

func _on_animated_sprite_3d_frame_changed() -> void:
	set_shader_params()
