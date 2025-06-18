extends Node

signal room_joined
signal new_player_joined_room(player_id: String)
signal error_joining_room(error_message: String)
signal player_list_changed
#signal error_joining_room()
signal room_created(room_id: String)
signal room_deleted
signal connected_to_server
signal connection_to_server_failed
signal bomb_exploded(player_owner: Player)
signal game_over(player_id: String)

func emit_bomb_exploded(player_owner: Player) -> void:
	bomb_exploded.emit(player_owner)
	
func emit_game_over(player_id: String) -> void:
	game_over.emit(player_id)
	
func emit_connected_to_server() -> void:
	connected_to_server.emit()
	
func emit_player_list_changed() -> void:
	player_list_changed.emit()
	
func emit_connection_to_server_failed() -> void:
	connection_to_server_failed.emit()

func emit_room_created(room_id: String) -> void:
	room_created.emit(room_id)

func emit_room_joined() -> void:
	room_joined.emit()

func emit_room_deleted() -> void:
	room_deleted.emit()
	
func emit_error_joining_room(error_message: String) -> void:
	error_joining_room.emit(error_message)
