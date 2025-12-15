extends Control

func _on_quit_pressed() -> void:
	$ButtonPressSound.play();
	OS.delay_msec(1000)
	get_tree().quit()

func _on_play_pressed() -> void:
	$ButtonPressSound.play();
	OS.delay_msec(1000)
	var node := get_tree().get_first_node_in_group("GameState")
	
	assert(
		node is StateMachine, 
		"Make sure the first node in GameState global group is StateMachine"
	)
	
	var state_machine: StateMachine = node as StateMachine
	
	state_machine.change_state(state_machine.current_state, "Play")

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
