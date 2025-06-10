extends Node2D

const PLAYER = preload("res://scenes/player/player.tscn")

@onready var default_map: Node2D = $DefaultMap

func _ready() -> void:
	GameManager.is_running = true
