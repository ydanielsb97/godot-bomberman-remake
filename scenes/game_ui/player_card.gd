extends NinePatchRect

@onready var player_container: VBoxContainer = $MarginContainer/PlayerContainer
@onready var label: Label = $MarginContainer/Label
@onready var player_name_input: LineEdit = $MarginContainer/PlayerContainer/PlayerNameContainer/PlayerNameInput
@onready var player_name_label: Label = $MarginContainer/PlayerContainer/PlayerNameContainer/PlayerNameLabel
@onready var left_arrows_container: VBoxContainer = $MarginContainer/PlayerContainer/PlayerBodyContainer/LeftArrowsContainer
@onready var right_arrows_container: VBoxContainer = $MarginContainer/PlayerContainer/PlayerBodyContainer/RightArrowsContainer
@onready var texture_rect: TextureRect = $MarginContainer/PlayerContainer/PlayerBodyContainer/PlayerContainer/BodyContainer/TextureRect

@export var is_current_player: bool = false

func _ready() -> void:
	pass
	#if is_current_player:
		#player_container.show()
	#else:
		#

func _process(delta: float) -> void:
	pass
