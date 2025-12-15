extends Player

class_name Sal

func _ready() -> void:
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
	actor_setup.call_deferred()
	
	set_shader_params()
	health = max_health
	internal_damage = max_health
	
	health_bar.hide()
	health_bar.health.color = Color(0.80, 0.45, 0.63)
	
	game_status.connect(_on_game_status_change)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Weyland_Skill"):
		state_machine.change_state(state_machine.current_state, "Skill")
	elif Input.is_action_just_released("Weyland_Skill"):
		state_machine.change_state(state_machine.current_state, "Idle")
	
	if Input.is_action_just_pressed("ui_accept"):
		take_damage(10.0)

func _physics_process(delta: float) -> void:
		time_since_damage += delta
		
		if time_since_damage > heal_timer:
			var candidate_health: float = health + max_health * heal_percentage / 100.0 * delta
			health = clamp(candidate_health, candidate_health, max_health)

func take_damage(damage: float, _damager: Node3D = null) -> void:
	time_since_damage = 0
	
	internal_damage = health
	health_bar.take_damage()
	state_machine.change_state(state_machine.current_state, "Flinch")


func take_internal_damage(damage: float) -> void:
	health -= damage
	time_since_damage = 0
	health_bar.take_internal_damage()

func use_skill() -> void:
	take_internal_damage(max_health * 0.05 / 60)
