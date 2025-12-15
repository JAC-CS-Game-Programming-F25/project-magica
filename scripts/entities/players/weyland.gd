extends Player

class_name Weyland

@export var perfect_guard_frame_count: int = 10

var is_guarding: bool = false
var is_successful_parry: bool = false
var parry_elapsed: int = 99

func _ready() -> void:
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
	actor_setup.call_deferred()
	
	set_shader_params()
	health = max_health
	internal_damage = max_health
	
	health_bar.hide()
	health_bar.health.color = Color(0.60, 0.43, 0.63)
	
	game_status.connect(_on_game_status_change)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		take_damage(10.0)
	
	var state_name: String = state_machine.current_state.name
	if state_name == "Flinch" or state_name == "Parry":
		return
	
	if Input.is_action_just_pressed("Weyland_Skill"):
		state_machine.change_state(state_machine.current_state, "Skill")
	elif Input.is_action_just_released("Weyland_Skill"):
		state_machine.change_state(state_machine.current_state, "Idle")

func _physics_process(delta: float) -> void:
	if health < internal_damage and !is_guarding:
		time_since_damage += delta
		
		if time_since_damage > heal_timer:
			var candidate_health: float = health + max_health * heal_percentage / 100.0 * delta
			health = clamp(candidate_health, candidate_health, max_health)

func take_damage(damage: float, damager: Node3D = null) -> void:
	if is_successful_parry:
		return
	
	if parry_elapsed <= perfect_guard_frame_count and is_guarding:
		state_machine.change_state(state_machine.current_state, "Parry", damager)
		return
	
	time_since_damage = 0
	health -= damage * (0.25 if is_guarding else 1.0)
	
	if !is_guarding:
		internal_damage = health
		health_bar.take_damage()
		state_machine.change_state(state_machine.current_state, "Flinch")
		return
	else:
		health_bar.take_internal_damage()

func take_internal_damage(damage: float) -> void:
	health -= damage
	time_since_damage = 0
	health_bar.take_internal_damage()

func use_skill() -> void:
	parry_elapsed += 1
	take_internal_damage(max_health * 0.05 / 60)


func _on_area_3d_body_entered(body: Node3D) -> void:
	print('entered')
	if body is not Enemy or !is_successful_parry:
		return
	
	(body as Enemy).take_damage(150.0)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Parry":
		(state_machine.current_state as PlayerParryState).parry_done.emit()
