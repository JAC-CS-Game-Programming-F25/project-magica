extends Camera3D

@export var players: Array[Player] = []

func _process(_delta: float) -> void:
	follow_players.call_deferred()

func follow_players() -> void:
	var positions: Array[Vector3] = []
	
	for p in players:
		positions.append(p.global_position)
	
	if positions.size() == 0:
		return
	
	if positions.size() == 1:
		global_position.x = positions[0].x
		return
	
	var average_x: float = 0.0
	var left_x: float = positions[0].x;
	var right_x: float = positions[0].x;
	
	for i in range(1, positions.size()):
		if positions[i].x < left_x:
			left_x = positions[i].x
		elif positions[i].x > right_x:
			right_x = positions[i].x
	
	average_x = (left_x + right_x) / 2.0
	global_position.x = average_x

func untrack_player(player: Player) -> void:
	for i in range(players.size()):
		if players[i] == player:
			players.remove_at(i)
			break
