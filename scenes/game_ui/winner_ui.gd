extends Control

@onready var winner_name_label: Label = $Panel/VBoxContainer/WinnerNameLabel

func _enter_tree() -> void:
	SignalHub.game_over.connect(on_game_over)

func on_game_over(player_id: int) -> void:
	var player = GameManager.players[player_id]
	if !player: 
		winner_name_label.text = "Winner has left"
		return
	winner_name_label.text = GameManager.players[player_id]["name"]
	show()
