extends Node2D

var danger=0
@export var dangerLossTime := 8
var timer = 0
var score = 0
var oldPos = Vector2(0,0)
@onready var placables = [$Pickup, $Pickup2, $Collectable]
@export var debug := false
var end = false
var inTutorial = true

var batteryTextures = [
	load("res://player/flashlight/batteryGauge/batterylvl-1.png.png"),
	load("res://player/flashlight/batteryGauge/batterylvl-2.png.png"),
	load("res://player/flashlight/batteryGauge/batterylvl-3.png.png"),
	load("res://player/flashlight/batteryGauge/batterylvl-4.png.png"),
	load("res://player/flashlight/batteryGauge/batterylvl-5.png.png")
]

func _ready() -> void:
	$Player/Flashlight.batteryChange.connect(_on_battery_change)
	$CanvasLayer/Centernotify/PopupText.modulate.a = 0.0
	$CanvasLayer/Centernotify/PopupText.text = "Press F to toggle your flashlight.\nThe dark is cold.\nMake it to shelter"
	placeItem($Collectable)
	placeItem($Pickup2)
	if debug:
		$Player/Flashlight/Camera2D/CanvasModulate.hide()
	$CanvasLayer/VBoxContainer/FlashlightDisplay.hide()
	$Player/Flashlight.hide()
		

func _on_battery_change(newBat):
	if debug:
		$Player/Flashlight.battery=100
	else:
		var batDisp = $CanvasLayer/VBoxContainer/FlashlightDisplay/BatteryTexture
		if newBat <= 1:
			batDisp.texture = batteryTextures[4]
		elif newBat <= 20:
			batDisp.texture = batteryTextures[3]
		elif newBat <= 50:
			batDisp.texture = batteryTextures[2]
		elif newBat <= 80:
			batDisp.texture = batteryTextures[1]
		else:
			batDisp.texture = batteryTextures[0]

func _process(delta: float) -> void:
	timer += delta * 1
	if $Player/Flashlight/Light.enabled:
		if danger > 0:
			danger -= 10 * delta
	else:
		if not(inTutorial):
			danger += 80 * delta / dangerLossTime
	$Player/Texture/PlayerAura.energy = 0.2+0.8-(danger/100)
	$CanvasLayer/DangerEdgeEffect.modulate.a = (danger)/100
	if danger >= 80:
		if not(end):
			gameEnd()

func gameEnd():
	end = true
	$Player.inputLock = true
	$CanvasLayer/Blackscreen/EndText.text = "You were unable to make it to your shelter.\nYou lasted " +str(int(timer)) + " seconds."
	fadeIn($CanvasLayer/Blackscreen)
	await get_tree().create_timer(5.0).timeout
	get_tree().reload_current_scene()
	

func _on_safe_zone_area_exited(body: Node2D) -> void:
	if body is Player:
		inTutorial=false
		$CanvasLayer/VBoxContainer/FlashlightDisplay.show()
		$Player/Flashlight.show()
		$"Tilemap Ground/Tilemap Tiles".set_cell(Vector2i(3,0),1,Vector2i(1,7))
		$"Tilemap Ground/Tilemap Tiles".set_cell(Vector2i(4,0),1,Vector2i(1,7))
		print(str(body) + " ended tutorial")
		fadeIn($CanvasLayer/Centernotify/PopupText)
		await get_tree().create_timer(10.0).timeout
		fadeOut($CanvasLayer/Blackscreen)
		$CanvasLayer/Centernotify/PopupText.text = ""
	
func _on_exit(body: Node2D) -> void:
	if body is Player:
		$CanvasLayer/Blackscreen/EndText.text = "You made it to your shelter after " + str(int(timer)) + " seconds.
		You brought " + str(score) + " shiny objects along the way."
		fadeIn($CanvasLayer/Blackscreen)
		await get_tree().create_timer(2.0).timeout	
		get_tree().paused = true

func _on_collectable(_body: Node2D) -> void:
	score += 1
	placeItem($Collectable)
	$Player/Texture/PlayerAura.scale.x += 0.1
	$Player/Texture/PlayerAura.scale.y += 0.1
	$Player/ItemPickupSFX.play()
		
func _on_battery_pickup(_body: Node2D) -> void:
	placeItem($Pickup)
func _on_battery2_pickup(_body: Node2D) -> void: #peak efficiency here :P
	placeItem($Pickup2) 

	
func placeItem(type):
	var placed = false
	oldPos = type.position
	while not(placed):
		for tiles in $"Tilemap Ground/Tilemap Tiles".get_used_cells():
			var tileData=$"Tilemap Ground/Tilemap Tiles".get_cell_tile_data(tiles)
			
			if tileData == null:
				continue
			elif tileData.get_custom_data("collectableSpawn"):
				if randi_range(1,10) == 1:
					placed = true
					type.position=tiles*64
					type.position.x+=32
					type.position.y+=32
					print("trying placement of " + str(type) + " at " + str(type.position))
					if type.position == oldPos:
						placed=false
						print("object didnt move, retrying")
					for i in placables:
						if i != type and i.position == type.position:
							placed=false
							print("placement already occupied by " + str(i) + ", retrying")

func fadeIn(target, length: float = 1.0):
	var tween = create_tween()
	tween.tween_property(target, "modulate:a", 1.0, length)
	await tween.finished
func fadeOut(target,length: float = 1.0):
	var tween = create_tween()
	tween.tween_property(target, "modulate:a", 0.0, length)
	await tween.finished
