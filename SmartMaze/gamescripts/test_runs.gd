extends Node

# Importáld a teszteseteket tartalmazó fájlt
const TestSuite = preload("res://gamescripts/test_step_count.gd")  # Cseréld ki a helyes elérési útra

func _ready():
	print("\nFuttatjuk a teszteket...")
	var suite = TestSuite.new()

	# Tesztesetek futtatása
	suite.wall_test()
	suite.test_step_count()

	print("\nMinden teszt lefutott.")
