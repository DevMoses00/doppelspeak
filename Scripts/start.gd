extends Node2D

# for when you can advance to the main game
var play_screen : bool = false
var skipped : bool = false

@export var layer1 : Sprite2D
@export var layer2 : Sprite2D
@export var layer3 : Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.fade_in_bgs("Restaurant",3.0)
	await get_tree().create_timer(2).timeout
	fade_tween($PrimaryBlack)
	await get_tree().create_timer(9).timeout
	text_opening()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func text_opening():
	# fadetweenin($Button)
	if skipped == false: 
		fade_tween_in($Label)
		await get_tree().create_timer(2).timeout
		# fade in a skip button
		fade_tween_in($SkipButton)
		$SkipButton.grab_focus()
		await get_tree().create_timer(7).timeout
		fade_tween_in($Label2)
		await get_tree().create_timer(9).timeout
	
	if skipped == false: 
		SoundManager.fade_out("Restaurant",3.0)
		$Background.hide()
		$Label.hide()
		$Label2.hide()
		$SkipButton.hide()
		$SkipButton.focus_mode = Control.FOCUS_NONE
		title_show()

func title_show():
	await get_tree().create_timer(3).timeout
	SoundManager.fade_in_bgm("Main",2.0)
	layer1.show()
	layer3.show()
	await get_tree().create_timer(6).timeout
	layer2.show()
	await get_tree().create_timer(6).timeout
	$PlayLabel.show()
	play_screen = true
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed():
		# don't do anything if play_screen isn't up
		if play_screen == false:
			return
		else:
		# turn off label
			# set it back to false
			play_screen = false 
			SoundManager.fade_out("Main",1.0)
			$PlayLabel.hide()
			SoundManager.play_sfx("Cup")
			await get_tree().create_timer(3).timeout
			SoundManager.stop_all()
			get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_skip_button_pressed() -> void:
		skipped = true
		SoundManager.play_sfx("Cup")
		$SkipButton.hide()
		$SkipButton.focus_mode = Control.FOCUS_NONE
		SoundManager.fade_out("Restaurant",3.0)
		$Background.hide()
		$Label.hide()
		$Label2.hide()
		title_show()

func fade_tween(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
	fadeTween.tween_interval(5)
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)

func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)

func fade_tween_out(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)
