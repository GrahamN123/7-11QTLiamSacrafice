extends CharacterBody2D

@export var speed: float = 220.0
@export var turn_speed: float = 3.5

func _physics_process(delta):
	var forward = Vector2.RIGHT.rotated(rotation)
	var accel = 0.0
	if Input.is_action_pressed("ui_up"):
		accel += 1.0
	if Input.is_action_pressed("ui_down"):
		accel -= 0.6
	velocity = forward * accel * speed
	if Input.is_action_pressed("ui_left"):
		rotation -= turn_speed * delta * sign(accel) if accel != 0 else turn_speed * delta
	if Input.is_action_pressed("ui_right"):
		rotation += turn_speed * delta * sign(accel) if accel != 0 else turn_speed * delta
	move_and_slide()
