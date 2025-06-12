extends CharacterBody2D

class_name Player

const BOMB = preload("res://scenes/bomb/bomb.tscn")
const ACCESSORY = preload("res://scenes/accessories/accessory.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collision_bomb_box: Area2D = $CollisionBombBox

@export var speed: float = 70.0
@export var bomb_strenght = 1
@export var bomb_max: int = 1
@export var is_walking: bool = false
@export var is_dead: bool = false
@export var current_bombs: int = 0
@export var player_id: int
@export var accessory_type: Accessory.AccessoryType
var authority_id: int

func _ready() -> void:
	add_to_group(GroupNames.PLAYERS)
	add_hat()
	authority_id = multiplayer.get_unique_id()
	var player_texture = GameManager.players[player_id]["skin"]
	sprite_2d.texture = SkinTextures.TEXTURES[player_texture]

func setup(_player_id: int) -> void:
	player_id = _player_id

func _unhandled_input(_event: InputEvent) -> void:
	if is_authority() and GameManager.is_running:
		if is_dead: return
		if Input.is_action_just_pressed("ui_accept"):
			drop_bomb()

func drop_bomb() -> void:
	if !can_drop_bomb(): return
	MultiplayerManager.rpc_drop_bomb_request.rpc_id(
		1,
		GameManager.room_code,
		player_id,
		global_position
	)

func can_drop_bomb() -> bool:
	return current_bombs < bomb_max and !is_dead

func _process(delta: float) -> void:
	if !is_authority() and !is_dead and GameManager.is_running:
		update_velocity_remotely()
		move_and_slide()
	

func _physics_process(delta: float) -> void:
	if is_authority() and !is_dead and GameManager.is_running:
		handle_movement()
		move_and_slide()


func is_authority() -> bool:
	return player_id == authority_id
	
func handle_movement() -> void:
	var axis_x: float = Input.get_axis("ui_left", "ui_right")
	var axis_y: float = Input.get_axis("ui_up", "ui_down")
	
	velocity = Vector2(
		axis_x * speed,
		axis_y * speed
	)
	MultiplayerManager.rpc_update_player_position_request.rpc_id(
		1,
		{
			"room_id": GameManager.room_code,
			"velocity": velocity,
			"position": position
		}
	)
	is_walking = velocity != Vector2.ZERO
	
	if velocity:
		animation_tree.set("parameters/Idle/blend_position", velocity)
		animation_tree.set("parameters/Walk/blend_position", velocity)

func update_velocity_remotely() -> void:
	var new_velocity = GameManager.players[player_id]["velocity"]
	position = GameManager.players[player_id]["position"]
	is_walking = new_velocity != Vector2.ZERO
	
	if new_velocity:
		animation_tree.set("parameters/Idle/blend_position", new_velocity)
		animation_tree.set("parameters/Walk/blend_position", new_velocity)

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if is_authority():
		MultiplayerManager.rpc_player_died_request.rpc_id(1, GameManager.room_code)
	
func die() -> void:
	is_dead = true

func add_hat() -> void:
	var new_accessory: Accessory = ACCESSORY.instantiate()
	new_accessory.animation_tree = animation_tree
	add_child(new_accessory)
	new_accessory.setup(accessory_type)
	new_accessory.position.y = -5
