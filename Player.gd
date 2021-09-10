extends Area2D

signal hit

export var speed = 400 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window

# The following fn is called when a node enters the scene tree
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# The following fn is called every frame
func _process(delta):
	# For the player, we need to do the following:
	# 1. Check for input
	# 2. Move in the given direction
	# 3. Play the appropriate animation
	var velocity = Vector2() # The player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta # `delta` is the frame length - the amount of time the prev frame took to ocmplete
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0



func _on_Player_body_entered(body):
	hide() # Player disappears after being hit
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

# Fn to reset player on start of a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
