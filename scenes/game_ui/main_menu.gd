extends Panel

@onready var loading: VBoxContainer = $MarginContainer/VBoxContainer/Loading
@onready var menu_buttons_container: VBoxContainer = $MarginContainer/VBoxContainer/MenuButtonsContainer
@onready var create_room_timeout: Timer = $MarginContainer/VBoxContainer/MenuButtonsContainer/CreateRoomTimeout
@onready var join_room_menu_container: VBoxContainer = $MarginContainer/VBoxContainer/JoinRoomMenuContainer
@onready var room_code_input: LineEdit = $MarginContainer/VBoxContainer/JoinRoomMenuContainer/RoomCodeInput
@onready var join_room_timeout: Timer = $MarginContainer/VBoxContainer/JoinRoomMenuContainer/JoinRoomTimeout

func _enter_tree() -> void:
	SignalHub.connected_to_server.connect(on_connected_to_server)
	SignalHub.room_created.connect(on_room_created)
	SignalHub.room_joined.connect(on_room_joined)

func try_join_room() -> void:
	loading.show()
	join_room_menu_container.hide()
	MultiplayerManager.rpc_join_room_request.rpc_id(
		1, 
		int(room_code_input.text),
		multiplayer.get_unique_id())
	join_room_timeout.start()

func on_connected_to_server() -> void:
	loading.hide()
	menu_buttons_container.show()
	
func on_room_created(_room_id: int) -> void:
	create_room_timeout.stop()
	await get_tree().create_timer(1).timeout
	loading.hide()
	menu_buttons_container.show()

func on_room_joined() -> void:
	join_room_timeout.stop()
	await get_tree().create_timer(1).timeout
	loading.hide()
	menu_buttons_container.show()

func _on_create_room_button_pressed() -> void:
	loading.show()
	menu_buttons_container.hide()
	MultiplayerManager.rpc_create_room_request.rpc_id(1, multiplayer.get_unique_id())
	create_room_timeout.start()

func _on_create_room_timeout_timeout() -> void:
	#Show error message
	loading.hide()
	menu_buttons_container.show()

func _on_join_room_button_pressed() -> void:
	menu_buttons_container.hide()
	join_room_menu_container.show()

func _on_back_menu_button_pressed() -> void:
	menu_buttons_container.show()
	join_room_menu_container.hide()


func _on_try_join_room_button_pressed() -> void:
	try_join_room()


func _on_room_code_input_text_submitted(_new_text: String) -> void:
	try_join_room()
