extends Node3D

class_name Game

@onready var camera: Camera3D = $Camera3D
@onready var weyland: Weyland = $Weyland
@onready var pause_menu: PauseMenu = $"CanvasLayer/PauseMenu"
@onready var canvas_layer: CanvasLayer = $CanvasLayer

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
		weyland.set_movement_target(closest_point_on_navmesh)

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
