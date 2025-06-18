extends Panel

@onready var room_code_label: Label = $MarginContainer/VBoxContainer/LobbyInformation/RoomCodeContainer/MarginContainer/HBoxContainer/RoomCodeLabel
@onready var start_button: Button = $MarginContainer/VBoxContainer/RoomActions/StartButton
@onready var copy_button: Button = $MarginContainer/VBoxContainer/LobbyInformation/CopyButton

func _enter_tree() -> void:
	SignalHub.room_deleted.connect(on_room_deleted)
	SignalHub.player_list_changed.connect(on_player_list_changed)

func on_player_list_changed() -> void:
	start_button.disabled = len(GameManager.players) <= 1

func on_room_deleted() -> void:
	SceneManager.load_an_scene(SceneManager.Scenes.MAIN_UI)

func _ready() -> void:
	GameManager.in_lobby = true
	GameManager.setup_players_cards()
	room_code_label.text = str(GameManager.room_code)
	start_button.visible = GameManager.is_admin
	on_player_list_changed()

func _on_texture_button_pressed() -> void:
	DisplayServer.clipboard_set(str(GameManager.room_code))
	copy_button.text = "Copied!"
	await get_tree().create_timer(1).timeout
	copy_button.text = "Copy"

func _on_exit_button_pressed() -> void:
	MultiplayerManager.leave_room_request()
	GameManager.clear_data()
	SceneManager.load_an_scene(SceneManager.Scenes.MAIN_UI)


func _on_start_button_pressed() -> void:
	start_button.disabled = true
	MultiplayerManager.start_game_request()
