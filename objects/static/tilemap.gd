extends TileMapLayer

var buttonState = 0
var tButtonState = 0
var placed = false
func _ready() -> void:
	buttonStateReload()

func _on_button_press(tutorial) -> void:
	buttonStateToggle(tutorial)

func _on_button_depress(tutorial) -> void:
	buttonStateToggle(tutorial)

func buttonStateToggle(tutorial):
	if tutorial:
		tButtonState += 1
		tButtonState %= 2
	else:
		buttonState += 1
		buttonState %= 2
	print("button:" + str(buttonState) + " tutorialButton:" + str(tButtonState))
	buttonStateReload()
	
func buttonStateReload():
	for tiles in get_used_cells():
		var tileData=get_cell_tile_data(tiles)	
		
		if tileData == null:
			continue
		
		var atlasCoord=get_cell_atlas_coords(tiles)

		var buttonValue = tileData.get_custom_data("buttonToggle")
		
		if buttonValue == 1 and buttonState == 1: #default on disabling
			set_cell(tiles,1,Vector2i(atlasCoord.x+6,atlasCoord.y))
		if buttonValue == 2 and buttonState == 0: #default off disabling
			set_cell(tiles,1,Vector2i(atlasCoord.x+6,atlasCoord.y))
		if buttonValue == 3 and buttonState == 0: #default on enabling
			set_cell(tiles,1,Vector2i(atlasCoord.x-6,atlasCoord.y))
		if buttonValue == 4 and buttonState == 1: #default off enabling
			set_cell(tiles,1,Vector2i(atlasCoord.x-6,atlasCoord.y))

		if buttonValue == 5 and tButtonState == 1: #default on disabling
			set_cell(tiles,1,Vector2i(atlasCoord.x+3,atlasCoord.y+2))
		if buttonValue == 6 and tButtonState == 0: #default off disabling
			set_cell(tiles,1,Vector2i(atlasCoord.x+3,atlasCoord.y+2))
		if buttonValue == 7 and tButtonState == 0: #default on enabling
			set_cell(tiles,1,Vector2i(atlasCoord.x-3,atlasCoord.y-2))
		if buttonValue == 8 and tButtonState == 1: #default off enablind
			set_cell(tiles,1,Vector2i(atlasCoord.x-3,atlasCoord.y-2))
