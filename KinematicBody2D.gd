extends KinematicBody2D

const MAX_SPEED : float = 100.0
const GRAVITY : float = 25.0
var motion := Vector2()

func _ready():
	motion.x = MAX_SPEED
	$AnimatedSprite.scale.x -1
	pass
func _next_to_left_wall() -> bool:
	return $leftRay.is_colliding()
	
func _next_to_right_wall() -> bool:
	return $Rilghtray.is_colliding()
	
func _floor_detection() ->bool:
	return $AnimatedSprite/FloorDetection.is_colliding()
	
func _flip():
	if _next_to_right_wall() or _next_to_left_wall() or !_floor_detection():
		motion.x *= -1
		$AnimatedSprite.scale.x *= -1
		
func _process(delta):
	motion.y += GRAVITY
	_flip()
	
	motion = move_and_slide(motion)
	pass
