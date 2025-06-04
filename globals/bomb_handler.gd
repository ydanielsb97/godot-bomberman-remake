extends Node

const BOMB = preload("res://scenes/bomb/bomb.tscn")
var floor_tile_map_ref: TileMapLayer

@rpc("any_peer", "call_local")
func drop_bomb(player_id: int, global_pos: Vector2) -> bool:
	var tile_map_layer: TileMapLayer = get_floor_tile_map()
	if !tile_map_layer: return false
	
	var map_pos = tile_map_layer.local_to_map(global_pos)
	var world_pos = tile_map_layer.map_to_local(map_pos)
	if check_bomb_exists_in_position(world_pos): return false
	var bomb_spawner: MultiplayerSpawner = get_node("/root/Main/BombsSpawner")
	bomb_spawner.spawn({
		"player_id": player_id,
		"position": world_pos
	})
	return true

func spawn_bomb(data: Dictionary) -> Bomb:
	var player: Player
	for p in get_tree().get_nodes_in_group(GroupNames.PLAYERS):
		if p.player_id == data.player_id: player = p
	var new_bomb: Bomb = BOMB.instantiate()
	new_bomb.player_ref = player
	new_bomb.global_position = data.position
	player.current_bombs += 1
	return new_bomb

func check_bomb_exists_in_position(pos: Vector2) -> bool:
	for bomb: Bomb in get_tree().get_nodes_in_group(GroupNames.BOMBS):
		if bomb.global_position == pos:
			return true
	return false

func get_floor_tile_map() -> TileMapLayer:
	if !floor_tile_map_ref:
		floor_tile_map_ref = get_tree().get_nodes_in_group(GroupNames.FLOOR_TILE_MAP)[0]
	return floor_tile_map_ref
