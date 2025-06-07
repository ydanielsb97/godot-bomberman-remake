extends Node

var room_code: String
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
		
var current_player_id = 1234 # Is going to be taken from multiplayer.get_unique_id()

var players: Dictionary = {
	1234: {
		"name": "Player",
		"skin": SkinTextures.Types.WHITE
	},
	12345: {
		"name": "Player1",
		"skin": SkinTextures.Types.RED
	},
	12346: {
		"name": "Player2",
		"skin": SkinTextures.Types.BLUE
	},
	12347: {
		"name": "Player3",
		"skin": SkinTextures.Types.GOLD
	}
}

func update_players_cards() -> void:
	var index: int = 0
	for player_id in players:
		cards[index].setup(
			player_id,
			player_id == current_player_id,
			players[player_id]["name"],
			players[player_id]["skin"]
			)
		index += 1

func update_player_name(player_id: int, player_name: String) -> void:
	players[player_id]["name"] = player_name

func update_player_skin(player_id: int, player_skin: SkinTextures.Types) -> void:
	players[player_id]["skin"] = player_skin

func get_index_player(player_id: int) -> int:
	return players.keys().find(player_id)
