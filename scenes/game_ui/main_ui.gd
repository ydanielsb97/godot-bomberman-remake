extends Control

@onready var main_menu: Panel = $MainMenu

func _enter_tree() -> void:
	SignalHub.room_created.connect(on_room_created)
	SignalHub.room_joined.connect(on_room_joined)

func on_room_created(room_id: int) -> void:
	SceneManager.load_an_scene(SceneManager.Scenes.ROOM_LOBBY)

func on_room_joined() -> void:
	SceneManager.load_an_scene(SceneManager.Scenes.ROOM_LOBBY)
