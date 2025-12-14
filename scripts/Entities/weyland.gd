extends CharacterBody3D

class_name Weyland

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var _state_machine: StateMachine = $StateMachine
@onready var _health_bar: HealthBar = $HealthBar

@export var movement_speed: float = 2.0
@export var max_health: float = 100.0
@export var flinch_duration_frames: int = 10
@export var heal_timer: float = 1.0
@export var heal_percentage: float = 20.0
@export var perfect_guard_frame_count: int = 10

var health: float
var internal_damage: float
var time_since_damage: float = 0.0
var is_guarding: bool = false

signal game_status

func _ready() -> void:
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
	actor_setup.call_deferred()
	
	set_shader_params()
	health = max_health
	internal_damage = max_health
	
	_health_bar.hide()
	_health_bar.health.color = Color(0.60, 0.43, 0.63)
	
	game_status.connect(_on_game_status_change)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Weyland_Skill"):
		_state_machine.change_state(_state_machine.current_state, "Skill")
	elif Input.is_action_just_released("Weyland_Skill"):
		_state_machine.change_state(_state_machine.current_state, "Idle")
	
	if Input.is_action_just_pressed("ui_accept"):
		take_damage(10.0)

func _physics_process(delta: float) -> void:
	if health < internal_damage and !is_guarding:
		time_since_damage += delta
		
		if time_since_damage > heal_timer:
			var candidate_health: float = health + max_health * heal_percentage / 100.0 * delta
			health = clamp(candidate_health, candidate_health, max_health)

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

func take_damage(damage: float) -> void:
	time_since_damage = 0
	health -= damage * (0.5 if is_guarding else 1.0)
	
	if !is_guarding:
		internal_damage = health
		_health_bar.take_damage()
		_state_machine.change_state(_state_machine.current_state, "Flinch")
	else:
		_health_bar.take_internal_damage()

func take_internal_damage(damage: float) -> void:
	health -= damage
	time_since_damage = 0
	_health_bar.take_internal_damage()

func use_skill() -> void:
	take_internal_damage(max_health * 0.05 / 60)

func _on_game_status_change(is_started: bool) -> void:
	if is_started:
		_health_bar.show()
	else:
		_health_bar.hide()
