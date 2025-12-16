extends Player

class_name Sal

@export var shooting_interval_frames: int = 300
@export var arrow_damage: float = 25.0
@onready var bow_sfx: AudioStreamPlayer = $BowSFX

var timer: int = 0

var enemies_in_range: Array[Enemy]

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

func _physics_process(delta: float) -> void:
	time_since_damage += delta
	
	if time_since_damage > heal_timer:
		var candidate_health: float = health + max_health * heal_percentage / 100.0 * delta
		health = clamp(candidate_health, candidate_health, max_health)
	
	if timer > shooting_interval_frames:
		if state_machine.current_state.name == EntityStates.idle and target != null:
			state_machine.change_state(state_machine.current_state, EntityStates.shoot, target)
	
	timer += 1

func take_damage(damage: float, _damager: Node3D = null) -> void:
	super.take_damage(damage, _damager)
	$HitSFX.play()
	if health <= 0:
		var game: Game = get_tree().get_first_node_in_group(GroupNames.game) as Game
		game.player_dead.emit(self)
		get_parent().remove_child(self)
		return
	time_since_damage = 0
	
	internal_damage = health
	health_bar.take_damage()
	state_machine.change_state(state_machine.current_state, EntityStates.flinch)


func take_internal_damage(damage: float) -> void:
	health -= damage
	time_since_damage = 0
	health_bar.take_internal_damage()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == EntityStates.shoot:
		(state_machine.current_state as PlayerShootState).anim_done.emit()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Enemy:
		if enemies_in_range.size() == 0:
			target = body
		enemies_in_range.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	for i in range(enemies_in_range.size()):
		if enemies_in_range[i] == body:
			enemies_in_range.remove_at(i)
	
	if enemies_in_range.size() == 0:
		target = null
