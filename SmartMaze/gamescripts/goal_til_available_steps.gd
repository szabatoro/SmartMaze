extends Node

func test_reach_goal_within_step_limit():
	# Lekérjük a játékos node-ját és a szülőjét (játék logikát kezelő node)
	var player = $Player
	var game_logic = player.get_parent()

	# Állítsuk be a teszt környezetet
	var initial_steps = 5
	var goal_tile = Vector2i(5, 5)  # Példa célcsempe
	player.current_tile = Vector2i(0, 0)
	player.global_position = player.tilemap.map_to_local(player.current_tile)
	game_logic.steps = initial_steps

	# Szimuláljuk a játékos mozgását a célcsempe irányába
	while player.current_tile != goal_tile and game_logic.steps > 0:
		# Számoljuk ki az irányt (egyszerű egyenes mozgás)
		var direction = (goal_tile - player.current_tile).sign()
		var next_tile = player.current_tile + direction

		# Mozgás szimulálása, ha a csempe érvényes
		if player.eligible_tiles.has(next_tile):
			player.current_tile = next_tile
			player.global_position = player.tilemap.map_to_local(next_tile)
			game_logic.steps -= 1

	# Assert, hogy a játékos a célnál van és maradt legalább 0 lépése
	assert(player.current_tile == goal_tile, "A játékos nem érte el a célcsempét.")
	assert(game_logic.steps >= 0, "A lépésszám negatív lett.")
