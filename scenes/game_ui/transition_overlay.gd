extends ColorRect

class_name TransitionOverlay

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_transitioning: bool = false
var overlay_is_visible: bool = false

func fade_in() -> void:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	overlay_is_visible = true


func fade_out() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	overlay_is_visible = false
