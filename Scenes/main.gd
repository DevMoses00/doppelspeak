extends Node2D

@export_group("Scenes")
@export var title : Node2D
@export var full : Node2D
@export var osimon : Node2D
@export var odawn : Node2D
@export var ocoffee : Node2D
@export_range (1, 4) var perspective: int

@export_group("Dialogue")
@export_enum ("Dawn", "Simon") var choice
@export var dialogue_key : String

@export_group("Character Sprites")
@export var bridgette_sprite : AnimatedSprite2D
@export var full_simon_sprite : AnimatedSprite2D
@export var full_dawn_sprite : AnimatedSprite2D

@export var osimon_simon_sprite : AnimatedSprite2D
@export var osimon_dawn_sprite : AnimatedSprite2D

@export var odawn_simon_sprite: AnimatedSprite2D
@export var odawn_dawn_sprite : AnimatedSprite2D


@export var ocoffee_dawn : AnimatedSprite2D
@export var ocoffee_simon : AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Read the JSON dialogue files
	DialogueManager.readJSON("res://Dialogue/DS_dialogue.json")
	DialogueMirrorManager.mirrorreadJSON("res://Dialogue/MirrorTest.json")
	signals_connect()
	fade_tween_in($Title)
	SoundManager.fade_in_bgm("Main",2.0)
	await get_tree().create_timer(3).timeout
	fade_tween_in($Button)
	SoundManager.fade_in_bgs("Restaurant", 2.0,0,-25)
	#mirror_dialogue_go(dialogue_key)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func signals_connect():
	DialogueManager.over_coffee_signaled.connect(over_coffee_view)
	DialogueManager.full_signaled.connect(full_view)
	DialogueManager.over_simon_signaled.connect(over_simon_view)
	DialogueManager.over_dawn_signaled.connect(over_dawn_view)
	DialogueManager.camera_zoom_signaled.connect(cam_zoom)
	DialogueManager.emptycup_signaled.connect(empty_cup)
	DialogueManager.camera_reset_signaled.connect(cam_reset)
	DialogueManager.endzoom_signaled.connect(endzoom)
	
	DialogueManager.opening_over.connect(dialogue_go.bind("EndOpening"))
	DialogueMirrorManager.opening_over.connect(mirror_dialogue_go.bind("EndOpening"))
	
	DialogueMirrorManager.end_opening_over.connect(mirror_remove_bridgette)
	DialogueManager.end_opening_over.connect(remove_bridgette)
	
	DialogueManager.choice_make.connect(make_choice)
	
	DialogueManager.choice_made.connect(dialogue_go.bind("CatchUp"))
	DialogueMirrorManager.choice_made.connect(mirror_dialogue_go.bind("CatchUp"))
	
	DialogueManager.catchup_over.connect(dialogue_go.bind("MoveAway"))
	DialogueMirrorManager.catchup_over.connect(mirror_dialogue_go.bind("MoveAway"))
	
	DialogueManager.moveaway_over.connect(dialogue_go.bind("Dreams"))
	DialogueMirrorManager.moveaway_over.connect(mirror_dialogue_go.bind("Dreams"))
	
	DialogueManager.dreams_over.connect(dialogue_go.bind("BigHeat"))
	DialogueMirrorManager.dreams_over.connect(mirror_dialogue_go.bind("BigHeat"))
	
	DialogueManager.bigheat_over.connect(dialogue_go.bind("Love"))
	DialogueMirrorManager.bigheat_over.connect(mirror_dialogue_go.bind("Love"))
	
	DialogueManager.love_over.connect(dialogue_go.bind("End"))
	DialogueManager.dawn_talking.connect(dawn_talking_speed)
	DialogueManager.simon_talking.connect(simon_talking_speed)
	DialogueManager.bridgette_talking.connect(bridgette_talking_speed)
	
	
	
	

func dialogue_go(dialogue_key):
	DialogueManager.dialogue_player(dialogue_key)

func mirror_dialogue_go(dialogue_key):
	DialogueMirrorManager.dialogue_player(dialogue_key)
	
# Removing Bridgette from the scene
func remove_bridgette():
	await get_tree().create_timer(2).timeout
	# play leaving sound
	SoundManager.play_sfx("GetUp")
	SoundManager.play_sfx("Leave")
	bridgette_sprite.reparent(self)
	bridgette_sprite.visible = false
	await get_tree().create_timer(3).timeout
	dialogue_go("EndIntro")
	pass

func mirror_remove_bridgette():
	# created to attach mirror dialogue
	await get_tree().create_timer(5).timeout
	mirror_dialogue_go("EndIntro")

# making the Dawn of Simon Choice
func make_choice():
	SoundManager.play_mfx("Magic")
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Question, "modulate:a",1,1)
	tween.tween_property($SimonButton,"modulate:a",1,2)
	tween.tween_property($DawnButton,"modulate:a",1,2)
	$SimonButton.disabled = false
	$DawnButton.disabled = false 

# button effects of those choices made
func _on_simon_button_pressed() -> void:
	$SimonButton.disabled = true
	$DawnButton.disabled = true
	print("SimonTime")
	DialogueManager.character_path = "Simon"
	DialogueMirrorManager.character_path = "Simon"
	SoundManager.play_sfx("Cup")
	$Full/Coffee.position = Vector2(-323,-66)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Question, "modulate:a",0,1)
	tween.tween_interval(1)
	tween.tween_property($SimonButton,"modulate:a",0,6)
	tween.tween_property($DawnButton,"modulate:a",0,2)
	tween.tween_property(ocoffee_simon,"modulate:a",0.6,4)
	SoundManager.fade_in_bgm("JazzE",6.0,0,-25)
	await get_tree().create_timer(2).timeout
	dialogue_go("Choice_Simon")
	mirror_dialogue_go("Choice_Simon")

func _on_dawn_button_pressed() -> void:
	$SimonButton.disabled = true
	$DawnButton.disabled = true
	DialogueManager.character_path = "Dawn"
	DialogueMirrorManager.character_path = "Dawn"
	print("DawnTime")
	SoundManager.play_sfx("Cup")
	$Full/Coffee.position = Vector2(-91,-95)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property($Question, "modulate:a",0,1)
	tween.tween_interval(1)
	tween.tween_property($SimonButton,"modulate:a",0,2)
	tween.tween_property($DawnButton,"modulate:a",0,6)
	tween.tween_property(ocoffee_dawn,"modulate:a",0.6,4)
	SoundManager.fade_in_bgm("JazzE",6.0,0,-25)
	await get_tree().create_timer(2).timeout
	dialogue_go("Choice_Dawn") 
	mirror_dialogue_go("Choice_Dawn")

# Perspective change functions
func over_coffee_view():
	full.visible = false
	osimon.visible = false
	odawn.visible = false
	ocoffee.visible = true
	DialogueManager.perspective = 4
	DialogueMirrorManager.perspective = 4

func full_view():
	full.visible = true
	osimon.visible = false
	odawn.visible = false
	ocoffee.visible = false
	DialogueManager.perspective = 1
	DialogueMirrorManager.perspective = 1

func over_simon_view():
	full.visible = false
	osimon.visible = true
	odawn.visible = false
	ocoffee.visible = false
	DialogueManager.perspective = 2
	DialogueMirrorManager.perspective = 2

func over_dawn_view():
	full.visible = false
	osimon.visible = false
	odawn.visible = true
	ocoffee.visible = false
	DialogueManager.perspective = 3
	DialogueMirrorManager.perspective = 3

# Additional Camera functions
func start_zoom():
	var tween = get_tree().create_tween()
	tween.tween_property($Title/Layer3, "modulate:a",0,3)
	tween.tween_interval(4)
	tween.tween_property($Camera2D,"zoom",Vector2(1,1),5)
	tween.parallel().tween_property($Title/Layer2,"modulate:a",0,3)
	tween.parallel().tween_property($Title/Layer1,"modulate:a",0,3)
	tween.tween_interval(7)
	tween.tween_callback(fade_in_characters)
	tween.tween_interval(3)
	tween.finished.connect(dialogue_go.bind(dialogue_key))

func fade_in_characters():
	var fadeTween = get_tree().create_tween().set_parallel()
	fadeTween.tween_property(bridgette_sprite,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
	fadeTween.tween_property(full_dawn_sprite,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
	fadeTween.tween_property(full_simon_sprite,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
func cam_zoom():
	# zooms the camera in when called via "Zoom:" in the script
	var tween = get_tree().create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(.1,.1),6).as_relative()

func cam_reset():
	$Camera2D.zoom = Vector2(1,1)

func empty_cup():
	SoundManager.play_sfx("Cup")
	SoundManager.fade_out("CutJazz",3.0)
	$Full/Coffee.modulate.a = 0 
	var tween = get_tree().create_tween()
	tween.tween_property($OverCoffee/Layer2,"modulate:a",0,3)

func endzoom():
	var tween = get_tree().create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(.5,.5),4)
	tween.tween_property($Title/Layer1,"modulate:a",1,5)
	#tween.parallel().tween_property($Title/Layer2,"modulate:a,",1,5)
	#tween.tween_property($Title/Layer3,"modulate:a,",1,2)
	tween.tween_interval(5)
	tween.finished.connect(endgame)
# Changing the speeds of the character animations when they speak
func simon_talking_speed():
	# slow bridgette
	bridgette_sprite.speed_scale = 1
	bridgette_sprite.self_modulate.a = 0.9
	
	# slow dawn
	ocoffee_dawn.speed_scale = 1
	ocoffee_dawn.self_modulate.a = 0.9
	
	full_dawn_sprite.speed_scale = 1
	full_dawn_sprite.self_modulate.a = 0.9
	
	osimon_dawn_sprite.speed_scale = 1
	osimon_dawn_sprite.self_modulate.a = 0.9
	
	odawn_dawn_sprite.speed_scale = 1
	odawn_dawn_sprite.self_modulate.a = 0.9
	
	# speed up simon
	full_simon_sprite.speed_scale = 2
	full_simon_sprite.modulate.a = 1
	
	osimon_simon_sprite.speed_scale = 2
	osimon_simon_sprite.self_modulate.a = 1
	
	ocoffee_simon.speed_scale = 2
	ocoffee_simon.self_modulate.a = 1
	
	odawn_simon_sprite.speed_scale = 2
	odawn_simon_sprite.self_modulate.a = 1

func bridgette_talking_speed():
	# speed up bridgette
	bridgette_sprite.speed_scale = 2
	bridgette_sprite.self_modulate.a = 1
	
	# slow dawn
	ocoffee_dawn.speed_scale = 1
	ocoffee_dawn.self_modulate.a = 0.9
	
	full_dawn_sprite.speed_scale = 1
	full_dawn_sprite.self_modulate.a = 0.9
	
	osimon_dawn_sprite.speed_scale = 1
	osimon_dawn_sprite.self_modulate.a = 0.9
	
	odawn_dawn_sprite.speed_scale = 1
	odawn_dawn_sprite.self_modulate.a = 0.9
	
	# slow simon
	full_simon_sprite.speed_scale = 1
	full_simon_sprite.modulate.a = 0.9
	
	osimon_simon_sprite.speed_scale = 1
	osimon_simon_sprite.self_modulate.a = 0.9
	
	ocoffee_simon.speed_scale = 1
	ocoffee_simon.self_modulate.a = 0.9
	
	odawn_simon_sprite.speed_scale = 1
	odawn_simon_sprite.self_modulate.a = 0.9

func dawn_talking_speed():
	# slow bridgette
	bridgette_sprite.speed_scale = 1
	bridgette_sprite.self_modulate.a = 0.9
	
	# speed up dawn
	ocoffee_dawn.speed_scale = 2
	ocoffee_dawn.self_modulate.a = 1
	
	full_dawn_sprite.speed_scale = 2
	full_dawn_sprite.self_modulate.a = 1
	
	osimon_dawn_sprite.speed_scale = 2
	osimon_dawn_sprite.self_modulate.a = 1
	
	odawn_dawn_sprite.speed_scale = 2
	odawn_dawn_sprite.self_modulate.a = 1
	
	# slow simon
	full_simon_sprite.speed_scale = 1
	full_simon_sprite.modulate.a = 0.9
	
	osimon_simon_sprite.speed_scale = 1
	osimon_simon_sprite.self_modulate.a = 0.9
	
	ocoffee_simon.speed_scale = 1
	ocoffee_simon.self_modulate.a = 0.9
	
	odawn_simon_sprite.speed_scale = 1
	odawn_simon_sprite.self_modulate.a = 0.9

func fade_tween_in(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 1.0), 2)
func fade_tween_out(image) -> void:
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property(image,"modulate",Color(1.0, 1.0, 1.0, 0.0), 2)
func endgame():
	await get_tree().create_timer(0.2).timeout
	$Full.visible = false
	await get_tree().create_timer(0.2).timeout
	SoundManager.fade_out("Main",1.0)
	$Title.visible = false
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/end.tscn")


func _on_button_pressed() -> void:
	$Button.hide()
	$Full.visible = true
	SoundManager.fade_out("Main",2.0)
	await get_tree().create_timer(2).timeout
	start_zoom()
