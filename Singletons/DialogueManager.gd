extends Node

# for the JSON file
var finish 

func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	finish = json.parse_string(content)
	return finish

@onready var text_box_scene = preload("res://Scenes/text_box.tscn")

var dialogue_lines
var current_line_index = 0

var text_box
var text_box_position: Vector2
var text_box_tween : Tween

var is_dialogue_active = false
var can_advance_line = false


signal dialogue_started

# for the character talking movements
signal dawn_talking
signal simon_talking
signal bridgette_talking

signal stop_talking

# signal for the one choice in this game 
signal choice_make

# signals for the different panel perspectives

signal over_simon_signaled
signal over_dawn_signaled
signal full_signaled
signal over_coffee_signaled

# which perspective we're in
var perspective : int = 1

# which story chapter we're in
var chapter : String
signal opening_over
signal catchup_over

func _ready() -> void:
	pass

# Create a new dialogue start function that takes a specific set of dialogue lines
func dialogue_player(line_key):
	if is_dialogue_active:
		return
	
	# change the chapter variable to the line key title 
	chapter = line_key
	
	dialogue_lines = finish[line_key]
	
	# if this is a regular dialogue line
	_show_text_box()
	is_dialogue_active = true

func _show_text_box():
	# for stage directions
	if dialogue_lines[current_line_index].begins_with("Time:"):
		print("this is working")
		# removes everything but the number in this line
		var timeNum = int(dialogue_lines[current_line_index].to_int())
		print(timeNum)
		# use it to create a timer based on that int num
		await get_tree().create_timer(timeNum).timeout 
		await get_tree().create_timer(1).timeout
		current_line_index += 1
		_show_text_box()
		return
	
	if dialogue_lines[current_line_index].begins_with("Ocoffee"):
		print("over coffee perspective")
		# send a signal to change the visible layer
		over_coffee_signaled.emit()
		await get_tree().create_timer(0.5).timeout
		current_line_index += 1 
		_show_text_box()
		return
	
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	
	if dialogue_lines[current_line_index].begins_with("D:"):
		# Play a Dawn sound
		
		# change position depending on what a name of a variable is
		
		#Full
		text_box.global_position = Vector2(200, -120)
		
		#Osimon
		
		#Odawn
		
		#Ocoffee - Simon Perspective
		
		#Ocoffee - Dawn Perspective
		
		dawn_talking.emit()
	
	elif dialogue_lines[current_line_index].begins_with("S:"):
		# Play a Simon sound

		# change position depending on what a name of a variable is
		
		#Full
		text_box.global_position = Vector2(-270, -200)
		
		#Osimon
		
		#Odawn
		
		#Ocoffee - Simon Perspective
		
		#Ocoffee - Dawn Perspective
		simon_talking.emit()
		
	elif dialogue_lines[current_line_index].begins_with("B:"):
		# Play a Bridgette sound
		
		# change position depending on what a name of a variable is
		#Full
		if perspective == 1:
			text_box.global_position = Vector2(200, 300)
		#Ocoffee
		elif perspective == 4: 
			text_box.global_position = Vector2(500, 400)
		bridgette_talking.emit()
	
	text_box_tween = get_tree().create_tween().set_loops()
	# tween animation
	text_box_tween.tween_property(text_box, "scale",Vector2(1.01,1.01),2)
	text_box_tween.tween_property(text_box, "scale",Vector2(.98,.98),2)
	
	text_box.display_text(dialogue_lines[current_line_index])
	
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("advance_dialogue") &&
		is_dialogue_active &&
		can_advance_line
	):
		text_box_tween.kill() # kill the tween loop
		text_box.queue_free()
		# have their mouths stop moving
		stop_talking.emit()
		
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			is_dialogue_active = false
			current_line_index = 0
			# send a signal saying that this line is over and a new action must occur?
			if chapter == "Opening":
				opening_over.emit()
			elif chapter == "CatchUp":
				choice_make.emit()
			return
		
		_show_text_box()


func skip_dialogue():
	current_line_index = int(dialogue_lines.size())
	text_box.queue_free()
	text_box_tween.kill()
	# have their mouths stop moving
	stop_talking.emit()
	is_dialogue_active = false
	current_line_index = 0
	# send a signal saying that this line is over and a new action must occur?
	choice_make.emit()
	return
