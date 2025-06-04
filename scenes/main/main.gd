extends Node2D

const PLAYER = preload("res://scenes/player/player.tscn")

@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var bombs_spawner: MultiplayerSpawner = $BombsSpawner
@onready var power_up_spawner: MultiplayerSpawner = $PowerUpSpawner

func _ready() -> void:
	player_spawner.spawn_function = spawn_players
	bombs_spawner.spawn_function = BombHandler.spawn_bomb
	power_up_spawner.spawn_function = PowerUpManager.custom_spawn_power_up
	
	await get_tree().create_timer(2).timeout
	if OS.has_feature("server"):
		DisplayServer.window_set_title("Bomberman - Server")
		MultiplayerManager.host_game()
	elif OS.has_feature("client"):
		DisplayServer.window_set_title("Bomberman - Client")
		MultiplayerManager.join_game()
	
	await get_tree().create_timer(2).timeout
	MultiplayerManager.start_game()

func spawn_players(data: Dictionary) -> Player:
	var spawn_points = get_tree().get_nodes_in_group(GroupNames.PLAYER_SPAWN_POINTS)
	var current_player = PLAYER.instantiate()
	var multiplayer_synchronizer: MultiplayerSynchronizer = current_player.get_node("./MultiplayerSynchronizer")
	current_player.player_id = data.peer_id
	multiplayer_synchronizer.set_multiplayer_authority(data.peer_id)
	var spawn_point: Marker2D = spawn_points[data.index]
	current_player.global_position = spawn_point.global_position
	return current_player
