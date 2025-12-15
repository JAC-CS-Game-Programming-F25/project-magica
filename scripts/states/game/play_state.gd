extends GameState

class_name GamePlayState

func _ready() -> void:
	(scene as Game).canvas_layer.hide()
	show_scene(false)

func enter(args = null) -> void:
	(scene as Game).level_music.play()
	(scene as Game).weyland.game_status.emit(true)
	(scene as Game).sal.game_status.emit(true)
	(scene as Game).er.game_status.emit(true)
	(scene as Game).canvas_layer.show()
	show_scene(true)

func exit() -> void:
	(scene as Game).level_music.stop()
	(scene as Game).weyland.game_status.emit(false)
	(scene as Game).sal.game_status.emit(false)
	(scene as Game).er.game_status.emit(false)
	(scene as Game).canvas_layer.hide()
	show_scene(false)

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
