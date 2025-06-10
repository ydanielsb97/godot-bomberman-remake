extends Panel

@onready var room_code_label: Label = $MarginContainer/VBoxContainer/LobbyInformation/RoomCodeContainer/MarginContainer/HBoxContainer/RoomCodeLabel
@onready var start_button: Button = $MarginContainer/VBoxContainer/RoomActions/StartButton
@onready var copy_button: Button = $MarginContainer/VBoxContainer/LobbyInformation/CopyButton

func _enter_tree() -> void:
	SignalHub.room_deleted.connect(on_room_deleted)

func on_room_deleted() -> void:
	SceneManager.load_an_scene(SceneManager.Scenes.MAIN_UI)

func _ready() -> void:
	GameManager.setup_players_cards()
	room_code_label.text = str(GameManager.room_code)
	start_button.visible = GameManager.is_admin

func _on_texture_button_pressed() -> void:
	DisplayServer.clipboard_set(str(GameManager.room_code))
	copy_button.text = "Copied!"
	await get_tree().create_timer(1).timeout
	copy_button.text = "Copy"

func _on_exit_button_pressed() -> void:
	MultiplayerManager.rpc_leave_room_request.rpc_id(
		1,
		GameManager.room_code,
		multiplayer.get_unique_id()
	)
	GameManager.clear_data()
	SceneManager.load_an_scene(SceneManager.Scenes.MAIN_UI)


func _on_start_button_pressed() -> void:
	MultiplayerManager.rpc_start_game_request.rpc_id(
		1,
		GameManager.room_code
	)
