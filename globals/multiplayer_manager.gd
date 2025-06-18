extends Node

const PLAYER = preload("res://scenes/player/player.tscn")
#const WS = "ws://localhost:3000/connection"
const WS = "ws://138.197.125.208/connection"

var socket: WebSocketPeer

@export var player_id: String

func _ready() -> void:
	socket = WebSocketPeer.new()
	socket.connect_to_url(WS)

func _process(delta):
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			ActionManager.exec_action(socket.get_packet().get_string_from_utf8())
	elif state == WebSocketPeer.STATE_CLOSING:
		print("Closing...")
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])

#func on_connection_failed() -> void:
	#print_debug("on_connection_failed")
	#SignalHub.emit_connection_to_server_failed()

func create_room_request() -> Error:
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.CREATE_ROOM
	}
	return socket.send_text(str(payload))
	
func join_room_request(room_id: String) -> Error:
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.JOIN_ROOM,
		"roomId": room_id
	}
	return socket.send_text(str(payload))
	
func leave_room_request() -> Error:
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.LEAVE_ROOM
	}
	return socket.send_text(str(payload))

func update_my_player_info(updates: Dictionary) -> void:
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.UPDATE_PLAYER_INFO,
		"updates": updates
	}
	return socket.send_text(str(payload))

func start_game_request() -> void:
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.START_GAME
	}
	return socket.send_text(str(payload))


func drop_bomb_request() -> void:
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.DROP_BOMB,
	}
	return socket.send_text(str(payload))

func explode_bomb_request(bomb_id: String, player_id_owner: String) -> void:
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.EXPLODE_BOMB,
		"bombId": bomb_id,
		"playerIdOwner": player_id_owner
	}
	return socket.send_text(str(payload))

func apply_power_up_request(player_id: String, power_up_id: String, power_up_type: int) -> void:
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.APPLY_POWER_UP,
		"playerId": player_id,
		"powerUpId": power_up_id,
		"powerUpType": power_up_type
	}
	return socket.send_text(str(payload))

func spawn_power_up_request(_position: Vector2) -> Error:
	var random_power_up: PowerUpManager.PowerUpType = PowerUpManager.get_random_power_up_type()
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.CREATE_POWER_UP,
		"position": {
			"x": _position["x"],
			"y": _position["y"],
		},
		"powerUpType": random_power_up
	}
	return socket.send_text(str(payload))

func player_died_request() -> void:
	var payload: Dictionary = {
		"action": WebsocketConstants.EnumActions.PLAYER_DIED,
	}
	return socket.send_text(str(payload))
