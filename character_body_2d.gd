extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var win_label = $Camera2D/WinLabel

const SPEED = 500.0
const JUMP_VELOCITY = -700.0

var coin_counter = 0

@onready var coin_label = $Camera2D/Label
func respawn():
	
	self.global_position = Vector2(28.667, 33.0)

func _physics_process(delta: float) -> void:
	
	# Add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "run"
	else:
		animated_sprite_2d.animation = "idle"
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jump"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("TOUCHED: ", area.name)
	print("GROUPS: ", area.get_groups())

	if area.name == "coin" or area.name == "coin2" or area.name == "coin3":
		set_coin(coin_counter + 1)
		print(coin_counter)
	
func set_coin(new_coin_count: int) -> void:
	coin_counter = new_coin_count
	coin_label.text = "Coin Counter: " + str(coin_counter)
	
	coin_counter = new_coin_count
	coin_label.text = "Coin Counter: " + str(coin_counter)

	if coin_counter == 3:
		win_game()
		
func win_game() -> void:
	win_label.visible = true
	get_tree().paused = true
