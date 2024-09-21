extends CharacterBody2D

# --------- VARIABLES ---------- #

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 10_000
@export var jump_force : float = 800
@export var gravity : float = 30
@export var max_jump_count : int = 2
var jump_count : int = 2

@export_category("Toggle Functions") # Double jump feature is disable by default (Can be toggled from inspector)
@export var double_jump : = false

var is_grounded : bool = false
var movement_enabled : bool = true

@onready var player_sprite = $AnimatedSprite2D

# --------- BUILT-IN FUNCTIONS ---------- #

func _physics_process(_delta):
	movement(_delta)

func _process(_delta):
	pass
	#player_animations()
	#flip_player()
	
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement(delta):
	# Gravity
	if !is_on_floor():
		velocity.y += gravity
	elif is_on_floor():
		jump_count = max_jump_count
	
	handle_jumping()
	
	# Move Player
	velocity = Vector2.ZERO

	velocity.x = move_speed * delta * Input.get_axis("ui_left", "ui_right")
	
	move_and_slide()

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if Input.is_action_just_pressed("ui_up") and movement_enabled:
		if is_on_floor() and !double_jump:
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1

# Player jump
func jump():
	jump_tween()
	velocity.y = -jump_force

# Handle Player Animations
func player_animations():
	
	if is_on_floor():
		if abs(velocity.x) > 0:
			player_sprite.play("Walk", 1.5)
		else:
			player_sprite.play("Idle")
	else:
		player_sprite.play("Jump")

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x < 0: 
		player_sprite.flip_h = true
	elif velocity.x > 0:
		player_sprite.flip_h = false

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)
