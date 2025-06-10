extends Area2D

class_name PowerUp

@export var type: PowerUpManager.PowerUpType = PowerUpManager.PowerUpType.BOMB
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = PowerUpManager.textures[type]

func setup(
	_type: PowerUpManager.PowerUpType, 
	_global_position: Vector2
	) -> void:
		type = _type
		global_position = _global_position

func _on_body_entered(player: Player) -> void:
	MultiplayerManager.rpc_apply_power_up_request.rpc_id(
		1,
		GameManager.room_code,
		player.player_id,
		type
	)
	
	MultiplayerManager.rpc_remove_power_up_request.rpc_id(
		1, 
		GameManager.room_code,
		name
		)

func apply_bomb_powerup(player: Player) -> void:
	player.bomb_max += 1
	
func apply_explosion_strength_powerup(player: Player) -> void:
	player.bomb_strenght += 1

func apply_speed_powerup(player: Player) -> void:
	player.speed += 20
