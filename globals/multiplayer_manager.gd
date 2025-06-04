extends Node

const PLAYER = preload("res://scenes/player/player.tscn")

const PORT: int = 27090
const MAX_PLAYERS: int = 4
const MY_IP: String = "192.168.5.185"

var peer

func _ready() -> void:
	multiplayer.peer_connected.connect(on_peer_connected)
	multiplayer.connected_to_server.connect(on_connected_to_server)

func on_connected_to_server() -> void:
	print_debug("on_connected_to_server", multiplayer.get_unique_id())

func start_game() -> void:
	if multiplayer.is_server():
		var peers: Array = multiplayer.get_peers()
		peers.push_front(1)
		for index in range(len(peers)):
			var peer_id = peers[index]
			GameManager.players[peer_id] = {
				"id": peer_id,
				"name": "Player-" + str(peer_id)
			}
			update_players.rpc(GameManager.players)
			var spawner: MultiplayerSpawner = get_node("/root/Main/PlayerSpawner")
			spawner.spawn({
				"peer_id": peer_id, 
				"index": index
				})

func on_peer_connected(id: int) -> void:
	print_debug("on_peer_connected", id)

func host_game() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer

func join_game() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(MY_IP, PORT)
	multiplayer.multiplayer_peer = peer

@rpc("call_remote")
func update_players(players: Dictionary) -> void:
	GameManager.players = players
