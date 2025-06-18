extends Node

const BOMB = preload("res://scenes/bomb/bomb.tscn")
var floor_tile_map_ref: TileMapLayer

func drop_bomb(player_id: String, _global_position: Vector2, strength: int, uniqueName: String) -> bool:
	var player: Player = GameManager.players[player_id]["reference"]
	var tile_map_layer: TileMapLayer = get_floor_tile_map()
	if !tile_map_layer: return false
	
	var map_pos = tile_map_layer.local_to_map(_global_position)
	var world_pos = tile_map_layer.map_to_local(map_pos)
	if check_bomb_exists_in_position(world_pos): return false
	var new_bomb: Bomb = BOMB.instantiate()
	new_bomb.setup(player, world_pos, strength)
	get_bombs_container().add_child(new_bomb)
	new_bomb.name = uniqueName
	return true

func bomb_exploded(bomb_id) -> void:
	for bomb: Bomb in get_bombs_container().get_children():
		if bomb.name == bomb_id:
			bomb.destroy_bomb()
			break

func get_bombs_container() -> Node2D:
	return get_node("/root/Main/BombsContainer")

func check_bomb_exists_in_position(pos: Vector2) -> bool:
	for bomb: Bomb in get_tree().get_nodes_in_group(GroupNames.BOMBS):
		if bomb.global_position == pos:
			return true
	return false

func get_floor_tile_map() -> TileMapLayer:
	if !floor_tile_map_ref:
		floor_tile_map_ref = get_tree().get_nodes_in_group(GroupNames.FLOOR_TILE_MAP)[0]
	return floor_tile_map_ref
