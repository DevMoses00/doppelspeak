extends Camera2D

@export var circleRadius : int
@export var lerpFactor : int

@export var mouse_speed : float = 500.0

func _process(delta):
	_cameraSway(delta)
	# Get input vector from right stick (ensure joypad motion is mapped)
	#var input_vec := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	
	var input_vec: Vector2 = Vector2.ZERO
	## Use Input Map actions for "look_right/left/down/up"
	input_vec.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	input_vec.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	# Move the camera based on input
	position += input_vec.normalized() * mouse_speed * delta

### helper funcs
func _cameraSway(delta:float):
	# use built in godot funcs to get vector distance and angle
	var distToMouse:float = Vector2.ZERO.distance_to(get_local_mouse_position())
	var angleToMouse:float = Vector2.ZERO.angle_to_point(get_local_mouse_position())
	
	# if we're outside prescribed circle
	if distToMouse >= circleRadius:
		# use parametric form of circle to find closest point on circle
		var closestPoint:Vector2 = Vector2(
			circleRadius * cos(angleToMouse),
			circleRadius * sin(angleToMouse)
		)
		# lerp there
		position = lerp(
			position,
			closestPoint,
			lerpFactor * delta
		)
	else:
		# just lerp to mouse position
		position.x = lerp(
			position.x,
			get_local_mouse_position().x,
			lerpFactor * delta
		)
		position.y = lerp(
			position.y, 
			get_local_mouse_position().y,
			lerpFactor * delta
			)
