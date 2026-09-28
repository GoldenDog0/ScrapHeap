extends CharacterBody2D
class_name Player

@export_range(0, 1000) var speed := 120
# Called when the node enters the scene tree for the first time.
var inputLock = false

func _physics_process(_delta: float) -> void:
	if not(inputLock):
		get_player_input()
		if move_and_slide():
			resolve_collision()
		if velocity.length() != 0:
			if not($StepSFX.playing):
				$StepSFX.play()
	
		else:
			$StepSFX.stop()

func resolve_collision():
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MoveableObject
		if body:
			if not(Input.is_action_pressed("pull")):
				body.apply_impact(-100.0 * collision.get_normal())

func get_player_input():
	var vector := Input.get_vector("left","right","up","down")
	velocity = vector * speed
	if Input.is_action_pressed("pull"):
		velocity *= 0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	flashlight()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		print("flashlight toggled at " + str(position))

func flashlight():
	var mousePos = get_global_mouse_position()
	$Flashlight.look_at(mousePos)

func _on_pickup(_body: Node2D) -> void:
	$Flashlight.battery+=75
	if $Flashlight.battery > 100:
		$Flashlight.battery = 100
	$ItemPickupSFX.play()
