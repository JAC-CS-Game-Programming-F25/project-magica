extends CharacterBody3D

class_name Weyland

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var _state_machine: StateMachine = $StateMachine

@export var movement_speed: float = 2.0

func _ready() -> void:
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
	actor_setup.call_deferred()
	
	set_shader_params()

func change_state(new_state: String):
	_state_machine.change_state(_state_machine.current_state, new_state)

func actor_setup() -> void:
	await get_tree().physics_frame

func set_movement_target(movement_target: Vector3) -> void:
	var current_state: PlayerState = _state_machine.current_state
	if !(current_state is PlayerIdleState or current_state is PlayerWalkingState):
		return
	
	_state_machine.current_state.Transitioned.emit(_state_machine.current_state, "walking", movement_target)

func set_shader_params() -> void:
	var base_tex_path: String = "shader_parameter/base_texture"
	var current_frame: Texture2D = sprite.sprite_frames.get_frame_texture(
		sprite.animation, 
		sprite.frame
	)
	sprite.material_overlay.set(base_tex_path, current_frame)


func _on_animated_sprite_3d_frame_changed() -> void:
	set_shader_params()
