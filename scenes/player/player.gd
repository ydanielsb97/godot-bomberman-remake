extends CharacterBody2D

class_name Player

const BOMB = preload("res://scenes/bomb/bomb.tscn")
const ACCESSORY = preload("res://scenes/accessories/accessory.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var collision_bomb_box: Area2D = $CollisionBombBox

@export var speed: float = 3500.0
@export var bomb_strength = 1
@export var bomb_max: int = 1
@export var is_walking: bool = false
@export var is_dead: bool = false
@export var current_bombs: int = 0
@export var player_id: String
@export var accessory_type: Accessory.AccessoryType

var position_threshold: float = 10.0

var authority_id: String

func _ready() -> void:
	add_to_group(GroupNames.PLAYERS)
	add_hat()
	authority_id = MultiplayerManager.player_id
	var player_texture = int(GameManager.players[player_id]["skin"])
	sprite_2d.texture = SkinTextures.TEXTURES[player_texture]

func setup(_player_id: String) -> void:
	player_id = _player_id

func _unhandled_input(_event: InputEvent) -> void:
	if is_authority() and GameManager.is_running:
		if is_dead: return
		if Input.is_action_just_pressed("ui_accept"):
			drop_bomb()

func drop_bomb() -> void:
	if !can_drop_bomb(): return
	MultiplayerManager.drop_bomb_request()

func can_drop_bomb() -> bool:
	return !is_dead

func _process(delta: float) -> void:
	if !is_authority() and !is_dead and GameManager.is_running:
		update_velocity_remotely()
		move_and_slide()
	

func _physics_process(delta: float) -> void:
	if is_dead and !GameManager.is_running: return
	
	if is_authority():
		handle_movement(delta)
	else:
		update_velocity_remotely()
	move_and_slide()


func is_authority() -> bool:
	return player_id == authority_id
	
func handle_movement(delta: float) -> void:
	var axis_x: float = Input.get_axis("ui_left", "ui_right")
	var axis_y: float = Input.get_axis("ui_up", "ui_down")
	
	velocity = Vector2(
		axis_x * speed * delta,
		axis_y * speed * delta
	)
	MultiplayerManager.update_my_player_info({
		"velocity": {
			"x": velocity.x,
			"y": velocity.y
		},
		"position": {
			"x": position.x,
			"y": position.y
		}
	})
	is_walking = velocity != Vector2.ZERO
	
	if velocity:
		animation_tree.set("parameters/Idle/blend_position", velocity)
		animation_tree.set("parameters/Walk/blend_position", velocity)

func update_velocity_remotely() -> void:
	var player_position = GameManager.players[player_id]["position"]
	var new_position = Vector2(player_position["x"], player_position["y"])
	if position != new_position:
		var player_velocity = GameManager.players[player_id]["velocity"]
		
		var new_velocity = Vector2(player_velocity["x"], player_velocity["y"])
		

		var tween = create_tween()
		tween.tween_property(self, "position", new_position, .150).set_trans(Tween.TRANS_LINEAR)

		velocity = new_velocity
		#position = new_position
		is_walking = velocity != Vector2.ZERO
		
		if velocity:
			animation_tree.set("parameters/Idle/blend_position", velocity)
			animation_tree.set("parameters/Walk/blend_position", velocity)

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if is_authority():
		MultiplayerManager.player_died_request()
	
func die() -> void:
	is_dead = true

func add_hat() -> void:
	var new_accessory: Accessory = ACCESSORY.instantiate()
	new_accessory.animation_tree = animation_tree
	add_child(new_accessory)
	new_accessory.setup(accessory_type)
	new_accessory.position.y = -5
