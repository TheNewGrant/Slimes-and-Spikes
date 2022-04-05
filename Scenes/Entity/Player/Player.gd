class_name PlayerController
extends KinematicBody2D
"""Movement system for the slime player.  The player's movements will
consist of Horizontal movement or walking, jumping which may include
mid-air jumps, and dashing which is a a boost in a certain direction.
"""

# Move Data
export(int, -50, 50) var moveSpeed = 0                 # Speed
export(float, 0, 2, 0.01) var frictionIntensity = 0.95 # Slow percent
export(int, 0, 50, 1) var moveSensitivity = 0          # Speed to stop
export(float, 0, 2, 0.01) var airFriction = 0.95       # Slow in air
# Jump Data
export(int, 0, 2000, 10) var jumpStrength = 0
export(int, 0, 5) var jumpAmount = 1
export(int, 0, 100, 5) var gravityStrength = 0
var allowedJumps = jumpAmount
# Location Data
var velocity = Vector2.ZERO
# Surrounding Data
const FLOOR_NORMAL = Vector2(0, -1)


func _physics_process(_delta):
	moveHorizontally(-moveSpeed, "Left")
	moveHorizontally(moveSpeed, "Right")
	if allowedJumps != 0:
		jump(jumpStrength, "Jump")
	if is_on_floor() == true:
		resetAbilities()
		applyFriction(frictionIntensity, moveSensitivity)
	else:
		applyFriction(airFriction, moveSensitivity)
	applyGravity(gravityStrength)
	velocity = move_and_slide(velocity, FLOOR_NORMAL)


func _on_CollisionChecker_body_entered(body):
	if body.is_in_group("Spikes"):
		print("Spikey Collision Detected!")


func _on_CollisionChecker_area_entered(area):
	if area.is_in_group("Cutscene1"):
		print("First Cutscene detected")
	elif area.is_in_group("Cutscene2"):
		print("Second Cutscene detected")
	elif area.is_in_group("Cutscene3"):
		print("Third Cutscene detected")


func moveHorizontally(move_speed, button_name):
	if Input.is_action_pressed(button_name):
		velocity.x += move_speed
	return velocity


func applyGravity(gravity):
	velocity.y += gravity
	return velocity


func jump(jumpPower, button_name):
	if Input.is_action_just_pressed(button_name):
		velocity.y = -jumpPower
		allowedJumps -= 1
	return velocity


func resetAbilities():
	allowedJumps = jumpAmount


func applyFriction(frictionAmount, sensitivity):
	velocity.x *= frictionAmount
	if velocity.x < sensitivity and velocity.x > -sensitivity:
		velocity.x = 0
	return velocity

