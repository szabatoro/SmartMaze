extends CharacterBody2D

@export var tilemap: TileMap

const tile_size = 16 # egy adott pályablokk mérete px-ben beégetve
var current_tile:Vector2i # a játékos adott pillanatbeli tartózkodási helye
var eligible_tiles # nem fal blokkok
var moving = false

func starting_position():
	# a vektor a textúra atlaszban lévő koordináták közül a járható úté,
	# az ezekkel rendelkező blokkokat szedi össze
	eligible_tiles = tilemap.get_used_cells_by_id(0,-1,Vector2i(1,1),-1)
	# a játékos mindig a legelső nem fal blokkból indul
	current_tile = eligible_tiles.front()
	# az előbbi blokk pozícióját adjuk meg a játékos pozíciójának
	var player_start_pos = tilemap.map_to_local(current_tile)
	# elhelyezzük a játékost
	self.global_position = Vector2i(player_start_pos.x,player_start_pos.y)

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready # Megvárja a parent node-ban lévő script lefutását
	starting_position() # elhelyezi a játékost a kezdőpontban

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if moving == false: #ha nem mozgunk 
		if Input.is_action_pressed("down"):#irány vector választása és animáció kezdése lépéshanglejátszása
			move(Vector2i.DOWN)
			$AnimatedSprite2D.play("moveD")
			AudioPlayer.play_fx(Global.grass_step)
		elif Input.is_action_pressed("up"):
			move(Vector2i.UP)
			$AnimatedSprite2D.play("moveU")
			AudioPlayer.play_fx(Global.grass_step)
		elif Input.is_action_pressed("left"):
			move(Vector2i.LEFT)
			$AnimatedSprite2D.play("moveL")
			AudioPlayer.play_fx(Global.grass_step)
		elif Input.is_action_pressed("right"): 
			move(Vector2i.RIGHT)
			$AnimatedSprite2D.play("moveR")
			AudioPlayer.play_fx(Global.grass_step)
		
func move(direction:Vector2i):
	if direction: #létezik-e a vector
		# adott iránynak megfelelő következő koordinátája 
		var next_tile = current_tile + direction
		var tween = create_tween() # 'tween', a csuszáshoz használt funkció.
		moving = true #mostantól mozgunk
		if eligible_tiles.has(next_tile): # ha az adott irányban járható út van, lépünk
			current_tile = next_tile
			# mozgás a kövekező tile-ra
			tween.tween_property(self,"position",position+Vector2(direction)*tile_size,0.4)
			tween.tween_callback(move_end)
			match direction: # levononk egy lépést a megfelelő irányból
				Vector2i.DOWN:
					get_parent().steps_down -= 1
				Vector2i.UP:
					get_parent().steps_up -= 1
				Vector2i.LEFT:
					get_parent().steps_left -= 1
				Vector2i.RIGHT:
					get_parent().steps_right -= 1
		else: #falnak ütközés és visszalökés
			tween.tween_property(self,"position",position+Vector2(direction)*tile_size/4,0.2)
			tween.tween_property(self,"position",position,0.2)
			tween.tween_callback(move_end)

func move_end():
	moving = false #abbahagytuk a mozgást
	$AnimatedSprite2D.pause() #abbahagytuk az animációt

	# mivel a tilemap koordinátája lokális a player pedig globális, ezért át kell alakítanunk
	# globálissá a map_to_local függvénnyel
	#self.global_position = tilemap.map_to_local(current_tile)
