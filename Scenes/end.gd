extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade_tween_in($Background)
	SoundManager.fade_in_bgm("JazzBack",2.0)
	fade_tween_in($Coffee)
	fade_tween_in($Thanks)
	await get_tree().create_timer(1).timeout
	fade_tween_in($Title)
	await get_tree().create_timer(1).timeout
	fade_tween_in($Thanks2)
	fade_tween_in($VMLogo)
	fade_tween_in($Button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().quit()

func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
