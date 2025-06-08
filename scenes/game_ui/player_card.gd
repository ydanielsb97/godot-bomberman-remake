extends NinePatchRect
class_name PlayerCard

@onready var player_container: VBoxContainer = $MarginContainer/PlayerContainer
@onready var invite_player_label: Label = $MarginContainer/InvitePlayerLabel

@onready var player_name_input: LineEdit = $MarginContainer/PlayerContainer/PlayerNameContainer/PlayerNameInput
@onready var player_name_label: Label = $MarginContainer/PlayerContainer/PlayerNameContainer/PlayerNameLabel
@onready var left_arrows_container: VBoxContainer = $MarginContainer/PlayerContainer/PlayerBodyContainer/LeftArrowsContainer
@onready var right_arrows_container: VBoxContainer = $MarginContainer/PlayerContainer/PlayerBodyContainer/RightArrowsContainer
@onready var texture_rect: TextureRect = $MarginContainer/PlayerContainer/PlayerBodyContainer/PlayerContainer/BodyContainer/TextureRect

var is_current_player: bool = false
var player_name: String = ""
var player_texture: SkinTextures.Types = SkinTextures.Types.WHITE
var player_id: int

func setup(
	_player_id: int, 
	_is_current_player: bool, 
	_player_name: String, 
	_player_texture: SkinTextures.Types) -> void:
	
	is_current_player = _is_current_player
	player_name = _player_name
	player_id = _player_id
	player_texture = _player_texture
	update_card_info()

func clear() -> void:
	player_container.hide()
	invite_player_label.show()
	
func update_card_info() -> void:
	player_container.show()
	invite_player_label.hide()
	player_name_input.visible = is_current_player
	player_name_label.visible = !is_current_player
	left_arrows_container.visible = is_current_player
	right_arrows_container.visible = is_current_player
	player_name_label.text = player_name
	player_name_input.text = player_name
	var new_atlas = AtlasTexture.new()
	new_atlas.atlas = SkinTextures.TEXTURES[player_texture]
	new_atlas.region = Rect2(26, 0, 9, 12)
	texture_rect.texture = new_atlas

func update_player_basic_info(_player_name: String, _texture: SkinTextures.Types) -> void:
	player_name = _player_name
	player_texture = _texture
	player_name_label.text = player_name
	var new_skin = SkinTextures.TEXTURES[player_texture]
	texture_rect.texture.set("atlas", SkinTextures.TEXTURES[player_texture])

func update_texture() -> void:
	var new_skin = SkinTextures.TEXTURES[player_texture]
	texture_rect.texture.set("atlas", SkinTextures.TEXTURES[player_texture])
	MultiplayerManager.rpc_update_my_player_info.rpc_id(
		1,
		int(GameManager.room_code),
		player_id,
		"skin",
		player_texture
	)

func update_label_name() -> void:
	player_name_label.text = player_name

func _on_player_name_input_text_changed(new_text: String) -> void:
	MultiplayerManager.rpc_update_my_player_info.rpc_id(
		1,
		int(GameManager.room_code),
		player_id,
		"name",
		new_text
	)

func _on_left_arrow_button_pressed() -> void:
	var new_index = player_texture - 1
	if new_index < 0: return
	player_texture = new_index
	update_texture()
	
func _on_right_arrow_button_pressed() -> void:
	var new_index = player_texture + 1
	if new_index > SkinTextures.Types.size() - 1: return
	player_texture = new_index
	update_texture()
