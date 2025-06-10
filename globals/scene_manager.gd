extends Node

enum Scenes {
	MAIN,
	MAIN_UI,
	ROOM_LOBBY
}

const TRANSITION_OVERLAY = preload("res://scenes/game_ui/transition_overlay.tscn")
const SCENES: Dictionary[Scenes, PackedScene] = {
	Scenes.MAIN: preload("res://scenes/main/main.tscn"),
	Scenes.MAIN_UI: preload("res://scenes/game_ui/main_ui.tscn"),
	Scenes.ROOM_LOBBY: preload("res://scenes/game_ui/room_lobby.tscn"),
}

var transition_overlay: TransitionOverlay
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transition_overlay = TRANSITION_OVERLAY.instantiate()
	add_child(transition_overlay)

func fade_in() -> void:
	if transition_overlay.overlay_is_visible: return
	await transition_overlay.fade_in()

func fade_out() -> void:
	if !transition_overlay.overlay_is_visible: return
	await transition_overlay.fade_out()

func load_an_scene(scene: Scenes) -> void:
	await fade_in()
	get_tree().change_scene_to_packed(SCENES[scene])
	fade_out()
