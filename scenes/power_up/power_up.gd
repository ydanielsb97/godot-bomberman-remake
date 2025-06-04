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
	match type:
		PowerUpManager.PowerUpType.BOMB:
			apply_bomb_powerup(player)
		PowerUpManager.PowerUpType.EXPLOSION:
			apply_explosion_strength_powerup(player)
			
	queue_free()

func apply_bomb_powerup(player: Player) -> void:
	player.bomb_max += 1
	
func apply_explosion_strength_powerup(player: Player) -> void:
	player.bomb_strenght += 1

func apply_speed_powerup(player: Player) -> void:
	player.speed += 20
