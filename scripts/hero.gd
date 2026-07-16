extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_VEL : int = 600
const FLAP_SPEED : int = -500
const START_POS = Vector2(100,400)
var flying: bool = true
var falling: bool = true


func _ready() -> void:
	reset()
	
func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)
	
	
func _physics_process(delta: float) -> void:
	if flying or falling:
		velocity.y += GRAVITY * delta
		# terminal velocity
		if velocity.y > MAX_VEL :
			velocity.y = MAX_VEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$owlet.play("owlet_jump")
		elif falling:
			$owlet/jump.play("hidden")
			$owlet.play("owlet_death") # cahgne this to a avaidl one
		move_and_collide(velocity * delta)
	else:
		if get_parent().game_over == true:
			$owlet.play("owlet_death")
			await $owlet.animation_finished
			$owlet.stop()
		else:
			$owlet.play("owlet_idle")
func flap():
	velocity.y = FLAP_SPEED
	$owlet/jump.play("jump")
	await $owlet/jump.animation_finished
	$owlet/jump.stop()
	
