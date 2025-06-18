extends Node

class_name ActionHandler

static func connected(payload: Dictionary) -> void:
	MultiplayerManager.player_id = payload["playerId"]
	SignalHub.emit_connected_to_server()

static func create_room_response(payload: Dictionary) -> void:
	GameManager.setup(payload["roomId"], {
		payload["player"]["id"]: payload["player"]
	})
	SignalHub.emit_room_created(payload["roomId"])

static func join_room_response(payload: Dictionary) -> void:
	GameManager.setup(payload["roomId"], payload["players"])
	SignalHub.emit_room_joined()

static func player_has_joined_broadcast(payload: Dictionary) -> void:
	GameManager.upsert_player(payload["player"]["id"], payload["player"])
	GameManager.setup_player_card(payload["player"]["id"])

static func player_has_left_broadcast(payload: Dictionary) -> void:
	GameManager.remove_player(payload["playerId"])
	GameManager.setup_players_cards()
	
static func room_deleted_broadcast(_payload: Dictionary) -> void:
	SignalHub.emit_room_deleted()
	GameManager.clear_data()

static func player_info_updated_broadcast(payload: Dictionary) -> void:
	if GameManager.in_lobby:
		GameManager.update_player(payload["playerId"], payload["playerInfo"])
		GameManager.update_player_card(payload["playerId"])

static func start_game_broadcast(payload: Dictionary) -> void:
	SceneManager.load_an_scene(SceneManager.Scenes.MAIN)

static func update_player_position_broadcast(payload: Dictionary) -> void:
	for p in payload["players"]:
		GameManager.players[p["id"]]["position"] = p["position"]
		GameManager.players[p["id"]]["velocity"] = p["velocity"]

static func drop_bomb_broadcast(payload: Dictionary) -> void:
	BombHandler.drop_bomb(
		payload["playerId"], 
		Vector2(payload["position"]["x"], payload["position"]["y"]),
		payload["strength"],
		payload["bombId"])

static func bomb_exploded_broadcast(payload: Dictionary) -> void:
	BombHandler.bomb_exploded(payload["bombId"])

static func create_power_up_broadcast(payload: Dictionary) -> void:
	var position = Vector2(payload["position"]["x"], payload["position"]["y"])
	PowerUpManager.spawn_power_up(position, payload["powerUpId"], int(payload["powerUpType"]))

static func remove_power_up_broadcast(payload: Dictionary) -> void:
	PowerUpManager.remove(payload["powerUpId"])

static func game_over_broadcast(payload: Dictionary) -> void:
	if GameManager.is_running:
		GameManager.game_over(payload["playerId"])

static func player_died_broadcast(payload: Dictionary) -> void:
	GameManager.players[payload["playerId"]]["reference"].die()

static func handle_error(payload: Dictionary) -> void:
	print_debug(payload["message"])
