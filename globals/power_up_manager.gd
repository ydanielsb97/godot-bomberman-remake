extends Node

enum PowerUpType {
	BOMB,
	EXPLOSION,
	#SPEED
}
const POWER_UP = preload("res://scenes/power_up/power_up.tscn")

const textures: Dictionary[PowerUpType, CompressedTexture2D] = {
	PowerUpType.BOMB: preload("res://assets/images/power_ups/bomb_powerup.png"),
	PowerUpType.EXPLOSION: preload("res://assets/images/power_ups/explosion_power_up.png"),
	#PowerUpType.SPEED: preload("res://assets/bomb_speed.png"),
}

const RATE_SPAWN: float = .4

func spawn_power_up(_global_position: Vector2) -> void:
	if !multiplayer.is_server(): return
	if !able_to_spawn(): return
	var power_up_spawner: MultiplayerSpawner = get_node("/root/Main/PowerUpSpawner")
	var power_up_type: PowerUpType = get_random_power_up_type()
	power_up_spawner.spawn({ 
		"global_position": _global_position,
		"power_up_type": power_up_type,
	})

func custom_spawn_power_up(data: Dictionary) -> Area2D:
	var new_power_up: Area2D = POWER_UP.instantiate()

	new_power_up.setup(
		data.power_up_type,
		data.global_position
	)
	return new_power_up

func get_random_power_up_type() -> PowerUpType:
	return PowerUpType.values().pick_random()

func able_to_spawn() -> bool:
	return randf() <= RATE_SPAWN
