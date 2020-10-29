extends KinematicBody2D

class_name ControlledBody2D#A class for easy-to-access custom physic bodies


var motion: Vector2
var snap: Vector2 = Vector2(0, 0)
var self_move: bool = false


func _physics_process(_delta: float) -> void:
	if not self_move:
		motion = move_and_slide_with_snap(motion, snap, Vector2(0, -1))


func impulse_x(power: float, max_power: float):
	max_power = abs(max_power)
	if abs(motion.x) < max_power:
		motion.x = clamp(motion.x + power, -max_power, max_power)
	
	return motion

func impulse_y(power: float, max_power: float):
	max_power = abs(max_power)
	if abs(motion.y) < max_power:
		motion.y = clamp(motion.y + power, -max_power, max_power)
	
	return motion


func friction_x(power: float):
	if power < abs(motion.x):
		motion.x -= power * sign(motion.x)
	else:
		motion.x = 0
	
	return motion

func friction_y(power: float):
	if power < abs(motion.y):
		motion.y -= power * sign(motion.y)
	else:
		motion.y = 0
	
	return motion
