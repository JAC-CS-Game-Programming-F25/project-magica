extends GameState

class_name GameMainMenuState

func enter(args = null) -> void:
	show_scene(true)

func exit() -> void:
	show_scene(false)

func process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
