class_name MoveableObject
extends CharacterBody2D

@export_range(0.0, 10.0) var drag := 5.0
@export_range(0.0, 1.0) var impact_response := 0.5
var isPullable := false

func _ready() -> void:
	$CollisionShape2D/PullArea.playerEnterBoxRange.connect(_onPullable)
	$CollisionShape2D/PullArea.playerLeftBoxRange.connect(_onUnpullable)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("pull"):
		if isPullable:
			for body in $CollisionShape2D/PullArea.get_overlapping_bodies():
				if body is Player:
					if (body.pullTarget == null or body.pullTarget == self) and body.isPulling:
						body.pullTarget = self
						var vector := Vector2(body.position-self.position)
						velocity = vector * 2.5

	if velocity.length_squared() > 1.0:
		velocity *= 1.0 - drag * delta
		if move_and_slide():
			resolve_collisions()

func _onPullable() -> void:
	print("on signal reached object")
	isPullable = true
	
func _onUnpullable() -> void:
	print("off signal reached object")
	isPullable = false

func resolve_collisions() -> void:
	var current_velocity = velocity
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MoveableObject
		if body:
			apply_impact(body.velocity)
			body.apply_impact(current_velocity)
		else:
			velocity -= velocity.project(collision.get_normal())
	
func apply_impact(impact_velocity: Vector2) -> void:
	velocity += ( impact_velocity - velocity ) * impact_response
