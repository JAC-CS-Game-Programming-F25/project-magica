extends CharacterBody3D

class_name Weyland

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var _sprite: AnimatedSprite3D = $AnimatedSprite3D

@export var movement_speed: float = 2.0

func _ready() -> void:
	_nav_agent.path_desired_distance = 0.5
	_nav_agent.target_desired_distance = 0.5
	actor_setup.call_deferred()

func _process(delta: float) -> void:
	pass

func  _physics_process(delta: float) -> void:
	if reached_target():
		_animation_player.play("Idle")
		return
	var next_position: Vector3 = _nav_agent.get_next_path_position()
	print(velocity)
	if position.x < next_position.x:
		_sprite.flip_h = false
	else:
		_sprite.flip_h	= true
		
	_animation_player.play("Walk") 
	global_position = global_position.move_toward(next_position, delta * movement_speed)

func actor_setup() -> void:
	await get_tree().physics_frame

func set_movement_target(movementTarget: Vector3) -> void:
	_nav_agent.set_target_position(movementTarget)

func reached_target() -> bool:
	return abs(self.position.x - _nav_agent.target_position.x) < 0.1 and \
		abs(self.position.z - _nav_agent.target_position.z) < 0.1 
