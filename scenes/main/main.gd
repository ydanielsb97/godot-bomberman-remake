extends Node2D

const PLAYER = preload("res://scenes/player/player.tscn")

@onready var player_spawner: MultiplayerSpawner = $PlayerSpawner
@onready var bombs_spawner: MultiplayerSpawner = $BombsSpawner
@onready var power_up_spawner: MultiplayerSpawner = $PowerUpSpawner
@onready var default_map: Node2D = $DefaultMap

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		MultiplayerManager.restart_match.rpc()
	elif event.is_action_pressed("start_new_game"):
		MultiplayerManager.start_game.rpc_id(1)

func _ready() -> void:
	player_spawner.spawn_function = spawn_players
	bombs_spawner.spawn_function = BombHandler.spawn_bomb
	power_up_spawner.spawn_function = PowerUpManager.custom_spawn_power_up
	
	if OS.has_feature("server"):
		DisplayServer.window_set_title("Bomberman - Server")
		MultiplayerManager.host_game()
	elif OS.has_feature("client"):
		DisplayServer.window_set_title("Bomberman - Client")
		MultiplayerManager.join_game()

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
