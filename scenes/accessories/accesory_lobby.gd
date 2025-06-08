extends Node2D

class_name AccessoryLobby

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

func setup(type: AccessoryType) -> void:
	sprite.texture = TEXTURES[type]

static func get_random() -> AccessoryType:
	return AccessoryType.values().pick_random()

static func get_texture_by_index(index: int) -> AccessoryType:
	return AccessoryType.values()[index]
