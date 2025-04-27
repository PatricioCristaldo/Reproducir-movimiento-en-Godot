extends CharacterBody2D

# Variables de movimiento
var speed = 200
var max_speed = 600
var jump_force = -300
var gravity = 800
var max_jumps = 2
var jumps_left = max_jumps
var friction = 0.1
var acceleration = 200
var is_jumping = false

# Referencia al nodo AnimationPlayer y los Sprite2D
var animation_player: AnimationPlayer
var idle_sprite: Sprite2D
var run_sprite: Sprite2D
var jump_sprite: Sprite2D

func _ready():
	# Conecta los nodos
	animation_player = $AnimationPlayer
	idle_sprite = $IdleSprite2D
	run_sprite = $RunSprite2D
	jump_sprite = $JumpSprite2D

func _input(event):
	if event.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
		animation_player.play("jump")  # Reproducir animación de salto
		_set_active_sprite(jump_sprite)  # Activar sprite de salto
	if event.is_action_released("ui_up"):
		is_jumping = false

func _physics_process(delta):
	# Aplicar gravedad
	velocity.y += gravity * delta

	# Restablecer saltos al estar en el suelo
	if is_on_floor():
		jumps_left = max_jumps
		if velocity.x == 0:  # Si el personaje no se mueve horizontalmente
			animation_player.play("idle")  # Reproducir animación de quieto
			_set_active_sprite(idle_sprite)  # Activar sprite de quieto
		else:  # Si el personaje se está moviendo
			animation_player.play("run")  # Reproducir animación de correr
			_set_active_sprite(run_sprite)  # Activar sprite de correr
	else:
			animation_player.play("jump")  # Reproducir animación de salto
			_set_active_sprite(jump_sprite)  # Activar sprite de salto

	# Movimiento lateral
	if Input.is_action_pressed("ui_left"):
		velocity.x -= acceleration * delta
		velocity.x = max(velocity.x, -max_speed)
	elif Input.is_action_pressed("ui_right"):
		velocity.x += acceleration * delta
		velocity.x = min(velocity.x, max_speed)
	else:
		velocity.x *= 1 - friction

	# Aplicar movimiento
	move_and_slide()

# Función para gestionar la visibilidad de los sprites
func _set_active_sprite(active_sprite: Sprite2D):
	idle_sprite.visible = false
	run_sprite.visible = false
	jump_sprite.visible = false
	active_sprite.visible = true
