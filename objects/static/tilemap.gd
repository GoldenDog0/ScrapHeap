extends TileMapLayer

var buttonState = 0
var placed = false
func _ready() -> void:
	buttonStateReload()

func _on_button_press() -> void:
	buttonStateToggle()
	print(buttonState)

func _on_button_depress() -> void:
	buttonStateToggle()
	print(buttonState)

func buttonStateToggle():
	buttonState += 1
	buttonState %= 2
	buttonStateReload()
	
func buttonStateReload():
	for tiles in get_used_cells():
		var tileData=get_cell_tile_data(tiles)	
		
		if tileData == null:
			continue
		
		var buttonValue = tileData.get_custom_data("buttonToggle")
		
		if buttonValue == 1 and buttonState == 1:
			set_cell(tiles,1,Vector2i(1,2))
		if buttonValue == 2 and buttonState == 0:
			set_cell(tiles,1,Vector2i(2,2))
		if buttonValue == 3 and buttonState == 0:
			set_cell(tiles,1,Vector2i(6,7))
		if buttonValue == 4 and buttonState == 1:
			set_cell(tiles,1,Vector2i(7,6))
