extends Node

const TRANSITION_OVERLAY = preload("res://scenes/game_ui/transition_overlay.tscn")

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
