## Draws a selected unit's walkable tiles.
extends TileMapLayer
class_name UnitOverlay


## Fills the tilemap with the cells, giving a visual representation of the cells a unit can walk.
func draw(cells: Array) -> void:
	clear()
	for cell in cells:
		set_cell(cell, 0, Vector2i(0,0), 0)
