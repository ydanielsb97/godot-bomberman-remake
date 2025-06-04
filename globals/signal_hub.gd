extends Node

signal bomb_exploded(player_owner: Player)

func emit_bomb_exploded(player_owner: Player) -> void:
	bomb_exploded.emit(player_owner)
