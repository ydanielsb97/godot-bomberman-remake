extends StaticBody2D

class_name Bomb

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

const EXPLOSION = preload("res://scenes/bomb/explosion.tscn")

var player_ref: Player
var floor_tile_map_ref: TileMapLayer
var exploding: bool = false

func _ready() -> void:
	pass

func setup(player: Player, world_position: Vector2) -> void:
	player_ref = player
	global_position = world_position

func explode() -> void:
	timer.stop()
	if exploding: return
	exploding = true
	player_ref.current_bombs -= 1
	animated_sprite_2d.hide()
	
	var new_exposion = EXPLOSION.instantiate()
	new_exposion.setup(player_ref.bomb_strenght)
	Callable(add_child).call_deferred(new_exposion)
	await get_tree().create_timer(.5).timeout
	MultiplayerManager.bomb_exploded.rpc_id(1, name)

func is_bomb_at_position(_position: Vector2) -> bool:
	for bomb in get_tree().get_nodes_in_group("bombs"):
		if bomb is Bomb and bomb.global_position == _position:
			return true
	return false

func _on_timer_timeout() -> void:
	explode()


func _on_hit_box_area_entered(_area: Area2D) -> void:
	explode()


func _on_player_detection_box_area_exited() -> void:
	collision_shape_2d.set_deferred("disabled", false)
