extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.fade_in_bgs("Restaurant",3.0)
	await get_tree().create_timer(2).timeout
	fade_tween($PrimaryBlack)
	await get_tree().create_timer(9).timeout
	fade_tween($Label)
	await get_tree().create_timer(9).timeout
	fade_tween($Label2)
	await get_tree().create_timer(9).timeout
	SoundManager.fade_out("Restaurant",3.0)
	fade_tween_out($Background)
	await get_tree().create_timer(3.5).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func fade_tween(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
	fadeTween.tween_interval(5)
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)

func fade_tween_out(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)
