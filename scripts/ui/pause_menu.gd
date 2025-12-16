extends Control

class_name PauseMenu

func _ready() -> void:
	hide()

func resume():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	show()

func _on_resume_pressed() -> void:
	resume()

func _on_quit_pressed() -> void:
	resume()
	
	var state_machine: StateMachine = get_tree().get_first_node_in_group(GroupNames.game_state) as StateMachine
	state_machine.change_state(state_machine.current_state, GameStates.main_menu)
