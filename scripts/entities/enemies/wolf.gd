extends Enemy

class_name Wolf

@export var damage_flash_duration: int = 5

@onready var whip_hitbox_area: Area3D = $WhipHitbox
@onready var whip_hitbox: CollisionShape3D = $WhipHitbox/CollisionShape3D

var knife_interval: int = 60
var timer = 0
var active_projectile: Projectile

var is_damaged: bool = false
var time_since_damage: int = 0

func _ready() -> void:
	set_shader_params()
	health = max_health

func _physics_process(delta: float) -> void:
	if is_damaged:
		if damage_flash_duration <= time_since_damage:
			sprite.modulate = Color(1.0, 1.0, 1.0)
			time_since_damage = 0
		time_since_damage += 1

func _on_animated_sprite_3d_sprite_frames_changed() -> void:
	set_shader_params()

func _on_whip_hitbox_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	(body as Player).take_damage(50.0, self)

func take_damage(damage: float, _damager: Node3D = null) -> void:
	super.take_damage(damage, _damager)
	print('wolf took damage')
	
	time_since_damage = 0
	is_damaged = true
	sprite.modulate = Color(1., 0.4, 0.4, 1.)
	
	if health < 0:
		state_machine.change_state(state_machine.current_state, "Death")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Die":
		(state_machine.current_state as EnemyDeathState).death_anim_done.emit()
	if anim_name == "Attack":
		(state_machine.current_state as EnemyAttackingState).attack_anim_done.emit()
