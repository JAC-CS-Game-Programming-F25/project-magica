extends GameState

class_name GamePlayState

func _ready() -> void:
	show_scene(false)

func enter(args = null) -> void:
	(scene as Game).weyland.game_status.emit(true)
	show_scene(true)

func exit() -> void:
	(scene as Game).weyland.game_status.emit(false)
	show_scene(false)

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
