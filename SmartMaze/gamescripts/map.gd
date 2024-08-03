extends TileMap

const MIN_MAZE_SIZE = 5
const MAZE_SAFETY_SIZE = 3
const STRETCH_RATIO = 2
const KILLSWITCH = 100
const PATH = 0
const WALL = 1

# a pályát leíró mátrix
var Maze = []

# Random funkció alsó és felső határral
func mrandom(min, max):
	return randi() % (max - min + 1) + min

# A mátrix előkészítése adott mérettel
func allocate_maze(s):
	Maze.resize(s)
	for i in range(s):
		Maze[i] = []
		Maze[i].resize(s)

# A pálya oldalainak és a bejáratok legenerálása
func maze_frame(s):
	for y in range(s):
		for x in range(s):
			if x == 0 or x == s - 1 or y == 0 or y == s - 1:
				Maze[x][y] = WALL
			else:
				Maze[x][y] = PATH
	Maze[1][0] = PATH
	Maze[s - 2][s - 1] = PATH

# Lyukelhelyezés a falakban - ModRecDiv használja
func make_path(start, length, wall_i, v):
	var path_i = mrandom(start, start + length - 1)
	if v:
		Maze[wall_i][path_i] = PATH
	else:
		Maze[path_i][wall_i] = PATH

# Módosított ekurzív elosztás - a pályát leíró mátrix generálása
func ModRecDiv(start_x, end_x, start_y, end_y, v):
	var hlength = end_x - start_x
	var vlength = end_y - start_y
	if hlength <= MAZE_SAFETY_SIZE or vlength <= MAZE_SAFETY_SIZE:
		return

	var wall_i = 0
	var sbound = 0
	var ebound = 0
	var tries = 0
	while true:
		wall_i = mrandom(start_x + 2, end_x - 2) if v else mrandom(start_y + 2, end_y - 2)
		sbound = Maze[wall_i][start_y] if v else Maze[start_x][wall_i]
		ebound = Maze[wall_i][end_y] if v else Maze[end_x][wall_i]
		if sbound == WALL and ebound == WALL:
			break
		tries += 1
		if tries >= KILLSWITCH:
			return

	for y in range(start_y, end_y + 1):
		for x in range(start_x, end_x + 1):
			if v:
				Maze[wall_i][y] = WALL
			else:
				Maze[x][wall_i] = WALL

	var start = start_y if v else start_x
	var length = vlength if v else hlength
	make_path(start + 1, length - 1, wall_i, v)
	if length > 5:
		make_path(start + 1, length - 1, wall_i, v)

	var nv = hlength >= vlength
	var nex_lu = wall_i if v else end_x
	var ney_lu = end_y if v else wall_i
	var nsx_rd = wall_i if v else start_x
	var nsy_rd = start_y if v else wall_i
	ModRecDiv(start_x, nex_lu, start_y, ney_lu, nv)
	ModRecDiv(nsx_rd, end_x, nsy_rd, end_y, nv)

# Pályagenerálás a legenerált mátrixból, több asset-tel már szerteágazóbb lesz
func mapgen(array):
	for i in range(array.size()):
		for j in range(array[i].size()):
			var celltype
			if array[i][j] == 1:
				celltype = Vector2i(0, 0)
			else:
				celltype = Vector2i(1, 0)
			self.set_cell(0, Vector2i(j, i), 1, celltype)

# Called when the node enters the scene tree for the first time.
func _ready():
	# a pálya mérete
	var s
	# ha nem adtunk meg méretet a főmenüben
	if Global.mapsize_setter == null:
		s = Global.mapsize
	# ha de
	else:
		Global.mapsize = Global.mapsize_setter
		s = Global.mapsize
	await owner.ready
	allocate_maze(s)
	maze_frame(s)
	ModRecDiv(0, s - 1, 0, s - 1, true)
	mapgen(Maze)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass










