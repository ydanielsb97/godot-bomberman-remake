extends Control

@onready var main_menu: Panel = $MainMenu
@onready var room_lobby: Panel = $RoomLobby

func _enter_tree() -> void:
	SignalHub.room_created.connect(on_room_created)
	SignalHub.room_deleted.connect(on_room_deleted)
	SignalHub.room_joined.connect(on_room_joined)
	SignalHub.room_left.connect(on_room_left)

func on_room_created(room_id: int) -> void:
	await SceneManager.fade_in()
	
	main_menu.hide()
	room_lobby.show()

func on_room_deleted() -> void:
	await SceneManager.fade_in()
	
	main_menu.show()
	room_lobby.hide()


func on_room_joined() -> void:
	await SceneManager.fade_in()
	
	main_menu.hide()
	room_lobby.show()

func on_room_left() -> void:
	await SceneManager.fade_in()
	
	main_menu.show()
	room_lobby.hide()
