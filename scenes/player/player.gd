extends CharacterBody2D

class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collision_bomb_box: Area2D = $CollisionBombBox
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

@export var speed: float = 70.0
@export var bomb_strenght = 1
@export var bomb_max: int = 1

const BOMB = preload("res://scenes/bomb/bomb.tscn")

@export var is_walking: bool = false
@export var is_dead: bool = false
@export var current_bombs: int = 0
@export var player_id: int

func _ready() -> void:
	add_to_group(GroupNames.PLAYERS)

func _unhandled_input(_event: InputEvent) -> void:
	if is_authority():
		if is_dead: return
		if Input.is_action_just_pressed("ui_accept"):
			drop_bomb()

func drop_bomb() -> void:
	if !can_drop_bomb(): return
	BombHandler.drop_bomb.rpc_id(1, player_id, global_position)
	
func can_drop_bomb() -> bool:
	return current_bombs < bomb_max

func _physics_process(_delta: float) -> void:
	if is_authority():
		if is_dead: return
		handle_movement()
		move_and_slide()

func is_authority() -> bool:
	return multiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()
	
func handle_movement() -> void:
	var axis_x: float = Input.get_axis("ui_left", "ui_right")
	var axis_y: float = Input.get_axis("ui_up", "ui_down")
	
	velocity = Vector2(
		axis_x * speed,
		axis_y * speed
	)
	is_walking = velocity != Vector2.ZERO
	
	if velocity:
		animation_tree.set("parameters/Idle/blend_position", velocity)
		animation_tree.set("parameters/Walk/blend_position", velocity)

func _on_area_2d_area_entered(_area: Area2D) -> void:
	is_dead = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		queue_free()
