extends Node

var room_code: int
var cards: Array[PlayerCard]:
	get:
		if !cards:
			var tree: SceneTree = get_tree()
			if tree:
				var found_cards: Array[Node] = tree.get_nodes_in_group(GroupNames.LOBBY_PLAYER_CARDS)
				for n in found_cards:
					if n is PlayerCard:
						cards.append(n)
		return cards

var players: Dictionary = {}

func setup(room_id: int, _players: Dictionary) -> void:
	players = _players
	room_code = room_id

func clear_data() -> void:
	players = {}
	room_code = 0

func upsert_player(player_id: int, player_info: Dictionary) -> void:
	players[player_id] = player_info

func remove_player(player_id: int) -> void:
	players.erase(player_id)

func setup_players_cards() -> void:
	var index: int = 0
	clear_cards()
	for player_id in players:
		cards[index].setup(
			player_id,
			player_id == multiplayer.get_unique_id(),
			players[player_id]["name"],
			players[player_id]["skin"]
			)
		index += 1

func clear_cards() -> void:
	for card in cards:
		card.clear()

func setup_player_card(player_id: int) -> void:
	var index: int = players.keys().find(player_id)
	cards[index].setup(
		player_id,
		player_id == multiplayer.get_unique_id(),
		players[player_id]["name"],
		players[player_id]["skin"]
		)

func update_player_card(player_id: int) -> void:
	var index: int = players.keys().find(player_id)
	cards[index].update_player_basic_info(
		players[player_id].name,
		players[player_id].skin
	)
	
func update_player_name(player_id: int, player_name: String) -> void:
	players[player_id]["name"] = player_name

func update_player_skin(player_id: int, player_skin: SkinTextures.Types) -> void:
	players[player_id]["skin"] = player_skin

func get_index_player(player_id: int) -> int:
	return players.keys().find(player_id)
