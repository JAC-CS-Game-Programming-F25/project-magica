extends Control

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	var node := get_tree().get_first_node_in_group("GameState")
	
	assert(
		node is StateMachine, 
		"Make sure the first node in GameState global group is StateMachine"
	)
	
	var state_machine: StateMachine = node as StateMachine
	
	state_machine.change_state(state_machine.current_state, "Play")
