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

const RATE_SPAWN: float = 1

func spawn_power_up(_global_position: Vector2, type: PowerUpType = get_random_power_up_type()) -> void:
	if !able_to_spawn(): return
	
	var power_up_container: Node2D = get_node("/root/Main/PowerUpContainer")
	var new_power_up: Area2D = POWER_UP.instantiate()

	new_power_up.setup(
		type,
		_global_position
	)
	power_up_container.add_child(new_power_up, true)
	#power_up_spawner.spawn({ 
		#"global_position": _global_position,
		#"power_up_type": power_up_type,
	#})

func spawn(data: Dictionary) -> Area2D:
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
