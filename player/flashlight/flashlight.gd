extends Sprite2D
@export_range(0.0,1.0,0.1) var strength := 0.8
@export_range(0.0,100.0) var battery := 2.5
@export_range(0.0,5.0) var batteryDrainRate := 2.0

signal batteryChange(newBattery: float)

var ticker = 0
var blink = 0
var state=0
var flashOn = load("res://player/flashlight/flashOn.png")
var flashOff = load("res://player/flashlight/flashOff.png")

func _ready() -> void:
	self.texture = flashOn
	batteryChange.emit(battery)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flashlight"):
		$Light.enabled = not($Light.enabled)
		$Click.play()

func _process(delta: float) -> void:
	if state == 0 and $Light.enabled:
		state = 1
		self.texture = flashOn
	elif state==1 and not($Light.enabled):
		state = 0
		self.texture = flashOff
		
	if $Light.enabled and self.visible:
		if battery>0:
			battery -= batteryDrainRate * delta
			ticker += 0.02 * delta
#			print(battery)
			$Light.energy = strength + sin(ticker)/10 - blink
			blink = 0
			if battery <= 50:
				if randi_range(0,int(battery*10)) == 1:
					blink=1
		else:
			battery=0
			$Light.enabled = false
	batteryChange.emit(battery)
