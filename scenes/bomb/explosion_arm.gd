extends Node2D

const EXPLOSION_EXTENDABLE_PART = preload("res://scenes/bomb/explosion_extendable_part.tscn")
const EXPLOSION_END_PART = preload("res://scenes/bomb/explosion_end_part.tscn")

func setup(length: int = 2) -> void:
	for part in range(1, length + 1):
		var new_explosion_part = EXPLOSION_EXTENDABLE_PART.instantiate()
		new_explosion_part.flip_v = part % 2 == 0
		add_child(new_explosion_part)
	
	var new_end_part = EXPLOSION_END_PART.instantiate()
	add_child(new_end_part)
