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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Read the JSON dialogue file
	DialogueManager.readJSON("res://Dialogue/DS_dialogue.json")
	signals_connect()
	await get_tree().create_timer(3).timeout
	dialogue_go("Opening")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func signals_connect():
	DialogueManager.over_coffee_signaled.connect(over_coffee_view)
	pass

func dialogue_go(dialogue_key):
	DialogueManager.dialogue_player(dialogue_key)


# Perspective change functions
func over_coffee_view():
	full.visible = false
	osimon.visible = false
	odawn.visible = false
	ocoffee.visible = true
	DialogueManager.perspective = 4

func full_view():
	full.visible = true
	osimon.visible = false
	odawn.visible = false
	ocoffee.visible = false
	DialogueManager.perspective = 1

func over_simon_view():
	full.visible = false
	osimon.visible = true
	odawn.visible = false
	ocoffee.visible = false
	DialogueManager.perspective = 2

func over_dawn_view():
	full.visible = false
	osimon.visible = false
	odawn.visible = true
	ocoffee.visible = false
	DialogueManager.perspective = 3
