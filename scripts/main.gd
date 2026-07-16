extends Node

@export var pipe_scene : PackedScene


var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 12
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	screen_size = get_viewport().get_visible_rect().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0 
	$score.text = "SCORE: " + str(score)
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	scroll = 0
	pipes.clear()
	generate_pipes()
	$hero.reset()
	
func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $hero.flying:
						$hero.flap()
						check_hit_top()

func start_game():
	game_running = true
	$hero.flying = true
	$hero.flap()
	$pipetimer.start()
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		scroll+= SCROLL_SPEED
		
		if scroll >= screen_size.x:
			scroll = 0
			
		$ground.position.x = -scroll
		
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED
		


func _on_pipetimer_timeout() -> void:
	generate_pipes()
	
func generate_pipes():
	
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y -ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(hero_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
	
func scored():
	score += 1
	$score.text = "SCORE: " + str(score)
	
	
func check_hit_top():
	if $hero.position.y < 0:
		$hero.falling = true
		stop_game()
		
func stop_game():
	$pipetimer.stop()
	$hero.flying = false
	game_running = false
	game_over = true
	$GameOver.show()
	
	
	
func hero_hit():
	$hero.falling = true
	stop_game()


func _on_ground_hit():
	$hero.falling = false
	stop_game()


func _on_game_over_restart() -> void:
	new_game()
