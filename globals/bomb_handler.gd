extends Node

const BOMB = preload("res://scenes/bomb/bomb.tscn")
var floor_tile_map_ref: TileMapLayer

func drop_bomb(player_id: int, _global_position: Vector2) -> bool:
	var player: Player = GameManager.players[player_id]["reference"]
	var tile_map_layer: TileMapLayer = get_floor_tile_map()
	if !tile_map_layer: return false
	
	var map_pos = tile_map_layer.local_to_map(_global_position)
	var world_pos = tile_map_layer.map_to_local(map_pos)
	if check_bomb_exists_in_position(world_pos): return false
	var new_bomb: Bomb = BOMB.instantiate()
	new_bomb.player_ref = player
	new_bomb.global_position = world_pos
	player.current_bombs += 1
	get_bombs_container().add_child(new_bomb)
	return true


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
