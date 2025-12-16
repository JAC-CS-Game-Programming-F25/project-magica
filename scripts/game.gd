extends Node3D

class_name Game

@onready var camera: Camera3D = $Camera3D
@onready var weyland: Weyland = $Weyland
@onready var sal: Sal = $Sal
@onready var er: Er = $Er
@onready var pause_menu: PauseMenu = $"CanvasLayer/PauseMenu"
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var level_music: AudioStreamPlayer = $LevelMusic

var players_alive: int = 3
var enemies_alive: int = 0
var current_level: int = 1
signal player_dead
signal enemy_dead

func _ready() -> void:
	player_dead.connect(_on_player_dead)
	enemy_dead.connect(_on_enemy_dead)
	level_music.stop()
	$CanvasLayer.hide()
	
	for c1 in get_children():
		if c1 is Level:
			for c2 in c1.get_children():
				if c2 is Enemy:
					enemies_alive += 1

func _unhandled_input(event: InputEvent) -> void:
	if _mouse_clicked(event):
		var mouse_cursor_position = event.position
		var camera_ray_length := 1000.0
		var camera_ray_start := camera.project_ray_origin(mouse_cursor_position)
		var camera_ray_end := camera_ray_start + camera.project_ray_normal(mouse_cursor_position) * camera_ray_length

		var closest_point_on_navmesh := NavigationServer3D.map_get_closest_point_to_segment(
			get_world_3d().navigation_map,
			camera_ray_start,
			camera_ray_end)
			
		if _should_player_move(event, "Weyland_Move"):
			weyland.set_movement_target(closest_point_on_navmesh)
		if _should_player_move(event, "Sal_Move"):
			sal.set_movement_target(closest_point_on_navmesh)
		if _should_player_move(event, "Er_Move"):
			er.set_movement_target(closest_point_on_navmesh)

func _mouse_clicked(event: InputEvent) -> bool:
	return event is InputEventMouseButton and \
		event.button_index == MOUSE_BUTTON_LEFT and \
		event.pressed
	 
func _unhandled_key_input(event: InputEvent) -> void:
	if _should_pause(event):
		pause_menu.pause() 

func _should_pause(event: InputEvent) -> bool:
	return event is InputEvent \
		and event.is_pressed() \
		and event.as_text() == 'Escape'
		
func _should_player_move(event: InputEvent, characterKey: String) -> bool:
	return event is InputEvent \
		and Input.is_action_pressed(characterKey) 

func _on_player_dead(player: Player) -> void:
	players_alive -= 1
	$Camera3D.untrack_player(player)
	
	if players_alive <= 0:
		level_music.stop()
		var state_machine = get_tree().get_first_node_in_group(GroupNames.game_state) as StateMachine
		state_machine.change_state(state_machine.current_state, GameStates.main_menu)
		
		var new_game = load("res://scenes/game.tscn").instantiate()
		add_sibling(new_game)
		(get_parent() as GamePlayState).scene = new_game
		get_parent().remove_child(self)
		queue_free()

func _on_enemy_dead() -> void:
	enemies_alive -= 1
	current_level += 1
	
	if enemies_alive <= 0:
		level_music.stop()
		var state_machine = get_tree().get_first_node_in_group(GroupNames.game_state) as StateMachine
		state_machine.change_state(state_machine.current_state, GameStates.main_menu)
		
		var new_level_path = "res://scenes/level%s.tscn" % current_level
		var new_level: Level = load(new_level_path).instantiate()
		var new_game: Game = load("res://scenes/game.tscn").instantiate()
		add_sibling(new_game)
		(get_parent() as GamePlayState).scene = new_game
		get_parent().remove_child(self)
		
		for c in new_game.get_children():
			if c is Level:
				new_game.remove_child(c)
				break
		new_game.add_child(new_level)
		$Level.queue_free()
		remove_child($Level)
		queue_free()
		
