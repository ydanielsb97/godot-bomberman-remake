extends Node

signal room_left
signal room_joined
signal new_player_joined_room(player_id: int)
signal error_joining_room(error_message: String)
#signal error_joining_room()
signal room_created(room_id: int)
signal room_deleted
signal connected_to_server
signal connection_to_server_failed
signal bomb_exploded(player_owner: Player)

func emit_bomb_exploded(player_owner: Player) -> void:
	bomb_exploded.emit(player_owner)

func emit_connected_to_server() -> void:
	connected_to_server.emit()

func emit_connection_to_server_failed() -> void:
	connection_to_server_failed.emit()

func emit_room_created(room_id: int) -> void:
	room_created.emit(room_id)

func emit_room_joined() -> void:
	room_joined.emit()

func emit_room_deleted() -> void:
	room_deleted.emit()
	
func emit_room_left() -> void:
	room_left.emit()
	
func emit_error_joining_room(error_message: String) -> void:
	error_joining_room.emit(error_message)
