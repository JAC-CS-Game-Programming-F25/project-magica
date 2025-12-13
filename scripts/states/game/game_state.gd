extends State

class_name GameState

@export var scene: Node;

func show_scene(visible: bool) -> void:
	if visible:
		scene.process_mode = Node.PROCESS_MODE_PAUSABLE
		scene.visible = true
	else:
		scene.process_mode = Node.PROCESS_MODE_DISABLED
		scene.visible = false
