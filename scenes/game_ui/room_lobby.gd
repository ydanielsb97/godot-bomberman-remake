extends Panel

@onready var room_code_label: Label = $MarginContainer/VBoxContainer/LobbyInformation/RoomCodeContainer/MarginContainer/HBoxContainer/RoomCodeLabel
@onready var start_button: Button = $MarginContainer/VBoxContainer/RoomActions/StartButton
@onready var copy_button: Button = $MarginContainer/VBoxContainer/LobbyInformation/CopyButton

func _enter_tree() -> void:
	SignalHub.room_created.connect(on_room_created)
	SignalHub.room_joined.connect(on_room_joined)

func on_room_created(room_id: int) -> void:
	room_code_label.text = str(room_id)
	await SceneManager.fade_in()
	start_button.show()

func on_room_joined() -> void:
	room_code_label.text = str(GameManager.room_code)
	await SceneManager.fade_in()
	start_button.hide()

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
	SignalHub.emit_room_left()
	GameManager.clear_data()
