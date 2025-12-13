extends GameState

class_name GamePlayState

func _ready() -> void:
	show_scene(false)

func enter(args = null) -> void:
	show_scene(true)

func exit() -> void:
	show_scene(false)

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
