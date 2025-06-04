extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var tile_map_layer: TileMapLayer

func _ready() -> void:
	tile_map_layer = get_tree().get_nodes_in_group(GroupNames.BREAKABLE_TILE_MAP)[0]
	
func _on_hurt_area_area_entered(_area: Area2D) -> void:
	if is_multiplayer_authority():
		break_wall.rpc()

@rpc("any_peer", "call_local")
func break_wall() -> void:
	animation_player.play("break")
	
#func _on_animation_player_animation_finished(_anim_name: String) -> void:
	#PowerUpManager.spawn_power_up(global_position)
	#var tile_pos: Vector2i = tile_map_layer.local_to_map(global_position)
	#tile_map_layer.erase_cell(tile_pos)
	#queue_free()
	#
func _on_animation_player_animation_finished(_anim_name: String) -> void:
	if multiplayer.is_server():
		finalize_break.rpc()

@rpc("any_peer", "call_local")
func finalize_break() -> void:
	PowerUpManager.spawn_power_up(global_position)
	var tile_pos: Vector2i = tile_map_layer.local_to_map(global_position)
	tile_map_layer.erase_cell(tile_pos)
	queue_free()
