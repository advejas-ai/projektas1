extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 1200.0
@export var friction: float = 1000.0

@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 1.2

var is_dashing: bool = false
var dash_time_left: float = 0.0
var cooldown_time_left: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var last_move_dir: Vector2 = Vector2.DOWN

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Track last movement direction for dash targeting
	if input_dir != Vector2.ZERO:
		last_move_dir = input_dir

	# Cooldown tick
	if cooldown_time_left > 0.0:
		cooldown_time_left -= delta

	# Dash trigger
	if Input.is_action_just_pressed("dash") and not is_dashing and cooldown_time_left <= 0.0:
		_start_dash(input_dir)

	# Dash active
	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0.0:
			_end_dash()
		else:
			velocity = dash_direction * dash_speed
			move_and_slide()
			return

	# Normal movement
	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

func _start_dash(input_dir: Vector2) -> void:
	is_dashing = true
	dash_time_left = dash_duration
	dash_direction = input_dir if input_dir != Vector2.ZERO else last_move_dir
	sprite.modulate = Color(1.0, 0.4, 0.2, 1)

func _end_dash() -> void:
	is_dashing = false
	cooldown_time_left = dash_cooldown
	velocity = dash_direction * max_speed * 0.5
	sprite.modulate = Color(1.0, 1.0, 1.0, 1)
