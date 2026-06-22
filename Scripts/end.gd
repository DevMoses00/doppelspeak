extends Node2D

var gamepad : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	SoundManager.fade_in_bgm("SadBack",2.0)

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		if gamepad == false: 
			return
		$Restart.release_focus()
		$Exit.release_focus()
		gamepad = false
		
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if gamepad == false:
			$Restart.grab_focus()
			gamepad = true


func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)


func _on_exit_pressed() -> void:
	$Exit.hide()
	SoundManager.stop_all()
	SoundManager.play_sfx("Cup")
	$Restart.focus_mode = Control.FOCUS_NONE
	$Exit.focus_mode = Control.FOCUS_NONE
	await get_tree().create_timer(3).timeout
	get_tree().quit()


func _on_restart_pressed() -> void:
	$Restart.hide()
	SoundManager.stop_all()
	SoundManager.play_sfx("Cup")
	$Restart.focus_mode = Control.FOCUS_NONE
	$Exit.focus_mode = Control.FOCUS_NONE
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
