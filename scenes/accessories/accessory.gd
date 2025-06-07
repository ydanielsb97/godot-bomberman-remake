extends Node2D

class_name Accessory

enum AccessoryType {
	TOP_HAT,
	CROWN,
	SANTA_HAT,
	PARTY_HAT
}
const TEXTURES: Dictionary[AccessoryType, CompressedTexture2D] = {
	AccessoryType.TOP_HAT: preload("res://assets/images/accessories/top_hat.png"),
	AccessoryType.CROWN: preload("res://assets/images/accessories/crown.png"),
	AccessoryType.SANTA_HAT: preload("res://assets/images/accessories/santa.png"),
	AccessoryType.PARTY_HAT: preload("res://assets/images/accessories/party_hat.png")
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Hat

@export var animation_tree: AnimationTree

var player_ref: Player

func _ready() -> void:
	player_ref = get_parent()

func setup(type: AccessoryType) -> void:
	sprite.texture = TEXTURES[type]

func _process(delta: float) -> void:
	var idle: Vector2 = animation_tree.get("parameters/Idle/blend_position")
	var walk: Vector2 = animation_tree.get("parameters/Walk/blend_position")
	sprite.flip_h = idle.x <= 0 or walk.x <= 0
	
	if player_ref.is_walking and animation_player.is_playing():
		animation_player.play("RESET")
	elif !player_ref.is_walking and !animation_player.is_playing():
		animation_player.play("hat_movement")

static func get_random() -> AccessoryType:
	return AccessoryType.values().pick_random()

static func get_texture_by_index(index: int) -> AccessoryType:
	return AccessoryType.values()[index]
