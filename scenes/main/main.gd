extends Node2D

const PLAYER = preload("res://scenes/player/player.tscn")

@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var bombs_spawner: MultiplayerSpawner = $BombsSpawner
@onready var power_up_spawner: MultiplayerSpawner = $PowerUpSpawner
@onready var default_map: Node2D = $DefaultMap

func _ready() -> void:
	pass

func spawn_players(data: Dictionary) -> Player:
	var spawn_points = get_tree().get_nodes_in_group(GroupNames.PLAYER_SPAWN_POINTS)
	var current_player = PLAYER.instantiate()
	var multiplayer_synchronizer: MultiplayerSynchronizer = current_player.get_node("./MultiplayerSynchronizer")
	var spawn_point: Marker2D = spawn_points[data.index]
	
	multiplayer_synchronizer.set_multiplayer_authority(data.peer_id)
	
	current_player.player_id = data.peer_id
	current_player.global_position = spawn_point.global_position
	current_player.accessory_type = Accessory.get_texture_by_index(data.index)
	return current_player
