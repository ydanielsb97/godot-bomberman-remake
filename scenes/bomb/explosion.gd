extends Node2D

const EXPLOSION_END_PART = preload("res://scenes/bomb/explosion_end_part.tscn")
const EXPLOSION_EXTENDABLE_PART = preload("res://scenes/bomb/explosion_extendable_part.tscn")
const EXPLOSION_ARM = preload("res://scenes/bomb/explosion_arm.tscn")
@onready var center: Area2D = $Center

@export var tile_map_layer: TileMapLayer
@export var breakable_walls_tile_map_layer: TileMapLayer
@export var length: int = 3
@export var wall_tile_ids: Array[int] = [0]

func _ready():
	tile_map_layer = get_tree().get_nodes_in_group(GroupNames.WALLS_TILE_MAP)[0]
	breakable_walls_tile_map_layer = get_tree().get_nodes_in_group(GroupNames.BREAKABLE_TILE_MAP)[0]
	
	for dir in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
		_spread_in_direction(Vector2i(dir))

func setup(_length = 1):
	length = _length
	
func _spread_in_direction(dir: Vector2i):
	for i in range(1, length + 1):
		var tile_pos = tile_map_layer.local_to_map(Vector2i(center.global_position) + dir * i * tile_map_layer.tile_set.tile_size)
		var tile_id = tile_map_layer.get_cell_source_id(tile_pos)
		
		if tile_id in wall_tile_ids:
			break

		var part: ExtendableExplosionPart = EXPLOSION_EXTENDABLE_PART.instantiate()
		part.position = dir * i * tile_map_layer.tile_set.tile_size
		part.rotation = Vector2(dir).angle()
		add_child(part)
		
		var tile_pos_breakable = breakable_walls_tile_map_layer.local_to_map(Vector2i(center.global_position) + dir * i * tile_map_layer.tile_set.tile_size)
		var tile_id_breakable = breakable_walls_tile_map_layer.get_cell_source_id(tile_pos_breakable)
		part.is_end = (i == length or _is_breakable(tile_id_breakable))
		
		if _is_breakable(tile_id_breakable):
			return

func _create_explosion(offset: Vector2):
	var explosion_part: ExtendableExplosionPart = EXPLOSION_EXTENDABLE_PART.instantiate()
	explosion_part.position = offset
	explosion_part.rotation = 0
	explosion_part.is_end = false
	add_child(explosion_part)

func _is_breakable(tile_id: int) -> bool:
	return tile_id == 1
