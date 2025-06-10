extends Node2D

var spawning_points: Array[Marker2D] = []
const PLAYER = preload("res://scenes/player/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawning_points.assign(get_tree().get_nodes_in_group(GroupNames.PLAYER_SPAWN_POINTS))
	spawn_players()

func spawn_players() -> void:
	var index: int = 0
	for player_id in GameManager.players:
		var player: Player = PLAYER.instantiate()
		var spawning_point: Marker2D = spawning_points[index]
		player.setup(player_id)
		player.global_position = spawning_point.global_position
		player.accessory_type = Accessory.get_texture_by_index(index)
		add_child(player)
		GameManager.players[player_id]["position"] = player.position
		GameManager.add_player_reference(player_id, player)
		index += 1
