extends Entity

class_name Enemy

@export var detection_sphere: Area3D
@export var attack_damage: float

var nearby_players: Array[Player] = []
var target: Player = null

func _on_detection_sphere_body_entered(body: Node3D) -> void:
	if is_dead:
		return
	
	if body is not Player:
		return
	nearby_players.append(body)
	target = body if target == null else target
	
	state_machine.change_state(state_machine.current_state, EntityStates.chase, body)

func _on_detection_sphere_body_exited(body: Node3D) -> void:
	if is_dead:
		return
	
	if body is not Player:
		return
	
	for i in range(nearby_players.size()):
		if nearby_players[i] == body:
			nearby_players.remove_at(i)
			break
	
	if nearby_players.is_empty():
		target = null
		state_machine.change_state(state_machine.current_state, EntityStates.idle)
		return
	
	var closest_player: Player = null
	var closest_distance: float
	for i in range(nearby_players.size()):
		if closest_player == null:
			closest_player = nearby_players[i]
			closest_distance = _get_distance(nearby_players[i].global_position, global_position)
			continue
		
		var distance: float = _get_distance(nearby_players[i].global_position, global_position)
		if distance < closest_distance:
			closest_player = nearby_players[i]
			closest_distance = distance
	
	state_machine.change_state(state_machine.current_state, EntityStates.chase, closest_player)

func _get_distance(pos1: Vector3, pos2: Vector3) -> float:
	return sqrt(
		pow(pos1.x - pos2.x, 2) +
		pow(pos1.y - pos2.y, 2) +
		pow(pos1.z - pos2.z, 2)
	)
