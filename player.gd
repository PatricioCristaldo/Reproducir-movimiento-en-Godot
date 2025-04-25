extends CharacterBody2D

var speed = 200
var max_speed = 600
var jump_force = -300
var gravity = 800
var max_jumps = 2
var jumps_left = max_jumps
var friction = 0.1
var acceleration = 200

func _input(event):
	if event.is_action_pressed("ui_up") and jumps_left > 0:
		velocity.y = jump_force
		jumps_left -= 1

func _physics_process(delta):
	# Aplicar gravedad
	velocity.y += gravity * delta

	# Restablecer saltos al estar en el suelo
	if is_on_floor():
		jumps_left = max_jumps

	# Movimiento lateral
	if Input.is_action_pressed("ui_left"):
		velocity.x -= acceleration * delta
		velocity.x = max(velocity.x, -max_speed)
	elif Input.is_action_pressed("ui_right"):
		velocity.x += acceleration * delta
		velocity.x = min(velocity.x, max_speed)
	else:
		velocity.x *= 1 - friction

	# Aplicar movimiento (sin argumentos)
	move_and_slide()
