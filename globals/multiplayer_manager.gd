extends Node

const PLAYER = preload("res://scenes/player/player.tscn")

const PORT: int = 27090
const MAX_ROOMS: int = 10
const MAX_PLAYERS_PER_ROOM = 4
const MAX_PLAYERS: int = 100
#const MY_IP: String = "161.35.189.235"
#const MY_IP: String = "127.0.0.1"
const MY_IP: String = "10.0.0.9"
var rooms = {}

func _ready() -> void:
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.connection_failed.connect(on_connection_failed)
	if OS.has_feature("server"):
		MultiplayerManager.host_game()
	else:
		MultiplayerManager.join_game()

func on_connected_to_server() -> void:
	print_debug("on_connected_to_server: ", multiplayer.get_unique_id())
	SignalHub.emit_connected_to_server()

func on_connection_failed() -> void:
	print_debug("on_connection_failed")
	SignalHub.emit_connection_to_server_failed()

func create_room() -> int:
	var new_id: int = generate_room_id()
	rooms[new_id] = {}
	return new_id

func can_create_room() -> bool:
	return len(rooms.keys()) <= MAX_ROOMS
	
func add_player_to_room(room_id: int, player_id: int, is_admin: bool = false) -> Variant:
	if !check_room_exists(room_id) or !can_join_room(room_id): return
	var new_player: Dictionary = {
		"is_admin": is_admin,
		"is_alive": true,
		"name": "",
		"skin": SkinTextures.Types.WHITE,
		"velocity": Vector2.ZERO,
		"position": Vector2.ZERO,
	}
	rooms[room_id][player_id] = new_player
	
	return new_player

func check_room_exists(room_id: int):
	return rooms.has(room_id)

func can_join_room(room_id: int):
	return len(rooms[room_id].keys()) < MAX_PLAYERS_PER_ROOM
	
func generate_room_id() -> int:
	var generated_id: int
	while !generated_id:
		var new_id: int = randi_range(1000, 9999)
		if !rooms.has(new_id): generated_id = new_id
	return generated_id

#region RPC CALLS

@rpc("any_peer", "call_remote")
func rpc_create_room_request(player_id: int) -> void:
	if !can_create_room(): return
	var room_id: int = create_room()
	add_player_to_room(room_id, player_id, true)
	rpc_create_room_response.rpc_id(player_id, room_id, rooms[room_id])

@rpc("authority", "call_remote")
func rpc_create_room_response(room_id: int, players: Dictionary) -> void:
	GameManager.setup(room_id, players)
	SignalHub.emit_room_created(room_id)

# -----------------------------

@rpc("any_peer", "call_remote")
func rpc_join_room_request(room_id: int, player_id: int) -> void:
	if !check_room_exists(room_id): return
	var new_player = add_player_to_room(room_id, player_id)
	if !new_player: return
	
	rpc_join_room_response.rpc_id(player_id, room_id, rooms[room_id])
	for _player_id in rooms[room_id]:
		if player_id != _player_id:
			_rpc_player_has_joined_broadcast.rpc_id(_player_id, player_id, new_player)

@rpc("authority", "call_remote")
func rpc_join_room_response(room_id: int, players: Dictionary) -> void:
	GameManager.setup(room_id, players)
	SignalHub.emit_room_joined()

@rpc("authority", "call_remote")
func _rpc_player_has_joined_broadcast(player_id: int, player_info: Dictionary) -> void:
	GameManager.upsert_player(player_id, player_info)
	GameManager.setup_player_card(player_id)

# -----------------------------

@rpc("any_peer", "call_remote")
func rpc_leave_room_request(room_id: int, leaving_player_id: int) -> void:
	var room = rooms[room_id]
	var player = room[leaving_player_id]
	
	if player["is_admin"]:
		for _player_id in room:
			if leaving_player_id != _player_id:
				_rpc_room_deleted_broadcast.rpc_id(_player_id)
		
		rooms.erase(room_id)
	else:
		for _player_id in room:
			if leaving_player_id != _player_id:
				_rpc_player_has_left_broadcast.rpc_id(_player_id, leaving_player_id)
		rooms[room_id].erase(leaving_player_id)
		if room.keys().is_empty():
			rooms.erase(room_id)
	
@rpc("authority", "call_remote")
func _rpc_player_has_left_broadcast(player_id: int) -> void:
	GameManager.remove_player(player_id)
	GameManager.setup_players_cards()
	
@rpc("authority", "call_remote")
func _rpc_room_deleted_broadcast() -> void:
	SignalHub.emit_room_deleted()
	GameManager.clear_data()

# -----------------------------

@rpc("any_peer", "call_remote", "reliable")
func rpc_update_my_player_info(
	room_id: int, 
	player_id: int, 
	info_to_update: String, 
	new_info: Variant) -> void:
	
	var room = rooms[room_id]
	if !room: return
	
	var player = room[player_id]
	if !player: return
	
	player[info_to_update] = new_info
	
	for _player_id in rooms[room_id]:
		_rpc_player_info_updated_broadcast.rpc_id(_player_id, player_id, player)

@rpc("authority", "call_remote")
func _rpc_player_info_updated_broadcast(player_id: int, player_info: Dictionary) -> void:
	GameManager.upsert_player(player_id, player_info)
	GameManager.update_player_card(player_id)

# -----------------------------

@rpc("any_peer", "call_remote")
func rpc_start_game_request(room_id: int) -> void:
	for _player_id in rooms[room_id]:
		rooms[room_id][_player_id]["is_alive"] = true
		_rpc_start_game_broadcast.rpc_id(_player_id)

@rpc("authority", "call_remote")
func _rpc_start_game_broadcast() -> void:
	SceneManager.load_an_scene(SceneManager.Scenes.MAIN)

# -----------------------------

@rpc("any_peer", "call_remote", "unreliable_ordered")
func rpc_update_player_position_request(data: Dictionary) -> void:
	var room = rooms[data["room_id"]]
	var player_id = multiplayer.get_remote_sender_id()
	var player = room[player_id]
	for _player_id in room:
		if player_id != _player_id:
			_rpc_update_player_position_broadcast.rpc_id(_player_id, player_id, data)

@rpc("authority", "call_remote", "unreliable_ordered")
func _rpc_update_player_position_broadcast(_player_id: int, data: Dictionary) -> void:
	GameManager.players[_player_id]["position"] = data["position"]
	GameManager.players[_player_id]["velocity"] = data["velocity"]

# -----------------------------

@rpc("any_peer", "call_remote", "unreliable")
func rpc_drop_bomb_request(room_id: int, player_id: int, _global_position: Vector2) -> void:
	for _player_id in rooms[room_id]:
		_rpc_drop_bomb_broadcast.rpc_id(_player_id, player_id, _global_position)

@rpc("authority", "call_remote")
func _rpc_drop_bomb_broadcast(player_id: int, _global_position: Vector2) -> void:
	BombHandler.drop_bomb(player_id, _global_position)

# -----------------------------

@rpc("any_peer", "call_remote", "reliable")
func rpc_create_power_up_request(room_id: int, global_position: Vector2) -> void:
	var random_power_up: PowerUpManager.PowerUpType = PowerUpManager.get_random_power_up_type()
	for _player_id in rooms[room_id]:
		_rpc_create_power_up_broadcast.rpc_id(_player_id, global_position, random_power_up)

@rpc("authority", "call_remote", "reliable")
func _rpc_create_power_up_broadcast(global_position: Vector2, random_power_up: PowerUpManager.PowerUpType) -> void:
	PowerUpManager.spawn_power_up(global_position, random_power_up)

@rpc("any_peer", "call_local", "reliable")
func rpc_remove_power_up_request(room_id: int, power_up_name: String) -> void:
	for _player_id in rooms[room_id]:
		_rpc_remove_power_up_broadcast.rpc_id(_player_id, power_up_name)
	
@rpc("authority", "call_remote", "reliable")
func _rpc_remove_power_up_broadcast(power_up_name: String) -> void:
	for power_up: PowerUp in get_tree().get_nodes_in_group(GroupNames.POWER_UP):
		if power_up.name == power_up_name: 
			power_up.queue_free()
			break

@rpc("any_peer", "call_remote", "reliable")
func rpc_apply_power_up_request(room_id: int, player_id: int, power_up_type: PowerUpManager.PowerUpType) -> void:
	for _player_id in rooms[room_id]:
		_rpc_apply_power_up_broadcast.rpc_id(_player_id, player_id, power_up_type)
	
@rpc("authority", "call_remote", "reliable")
func _rpc_apply_power_up_broadcast(player_id: int, power_up_type: PowerUpManager.PowerUpType) -> void:
	for player: Player in get_tree().get_nodes_in_group(GroupNames.PLAYERS):
		if player.player_id == player_id:
			match power_up_type:
				PowerUpManager.PowerUpType.BOMB:
					player.bomb_max += 1
				PowerUpManager.PowerUpType.EXPLOSION:
					player.bomb_strenght += 1

# -----------------------------

@rpc("any_peer", "call_remote", "reliable")
func rpc_player_died_request(room_id: int) -> void:
	var player_id: int = multiplayer.get_remote_sender_id()
	
	rooms[room_id][player_id]["is_alive"] = false
	
	var players_alive_count: Array[int] = get_players_alive(room_id)
	
	var player_id_winner: int
	
	if len(players_alive_count) == 1:
		player_id_winner = players_alive_count[0]
	elif len(players_alive_count) < 1:
		player_id_winner = player_id
	
	
	for _player_id in rooms[room_id]:
		rpc_player_died_broadcast.rpc_id(_player_id, player_id)
		if player_id_winner:
			rpc_game_over_broadcast.rpc_id(_player_id, player_id_winner)

@rpc("authority", "call_remote", "reliable")
func rpc_game_over_broadcast(player_id_winner: int) -> void:
	if GameManager.is_running:
		GameManager.game_over(player_id_winner)

@rpc("authority", "call_remote", "reliable")
func rpc_player_died_broadcast(player_id: int) -> void:
	GameManager.players[player_id]["reference"].die()

#endregion

func get_players_alive(room_id: int) -> Array[int]:
	var players_alive: Array[int] = []
	
	for player_id in rooms[room_id]:
		if rooms[room_id][player_id]["is_alive"]: players_alive.append(player_id)
	
	return players_alive

func on_peer_connected(id: int) -> void:
	print_debug("on_peer_connected", id)

func host_game() -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer

func join_game() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(MY_IP, PORT)
	multiplayer.multiplayer_peer = peer
