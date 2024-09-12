extends Node2D

# A pálya mérete, exportálva a könnyű tesztelhetőségért
# @export var mapsize = 20 !!EZT FELVÁLTOTTA A GLOBAL.GD!!
# A pálya, exportálva, hogy befolyásolhassuk az exportban megadott pálya asset méretét
@export var tilemap: TileMap

var start_steps
var steps

func get_steps():
	var msize = Global.mapsize
	return msize*msize/4

# Called when the node enters the scene tree for the first time.
func _ready():
	# lépések (placeholder kiszámító)
	start_steps = get_steps()
	steps = start_steps

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# ha elfogynak a lépések, újratölti a pályát
	if steps == 0:
		get_tree().paused = true
		$Gameover.show()
		#steps = start_steps
		#get_tree().reload_current_scene()		
	# Ha a játékos eléri a célt, a pálya végetér, új pálya indul (erősen félkész)
	if $Player.global_position == tilemap.map_to_local(tilemap.get_used_cells_by_id(0,-1,Vector2i(1,1),-1).back()):
		# a következő menetben a játék 4 egységgel lesz nagyobb
		Global.mapsize += 4
		Global.waittime += 10.0
		# újratöltjük a játékot, új pályát létrehozva ezzel
		var tree_status = get_tree()
		if tree_status != null:
			get_tree().reload_current_scene()

func _on_timer_timeout():
	steps = start_steps
	get_tree().reload_current_scene()


#func _on_gameover_id_pressed(0):
	#pass # Replace with function body.
