extends Node

# Importáld a teszteseteket tartalmazó fájlt
const TestSuite = preload("res://gamescripts/test_step_count.gd")  # Cseréld ki a helyes elérési útra

func _ready():
	print("\nFuttatjuk a teszteket...")
	var suite = TestSuite.new()

	# Tesztesetek futtatása
	suite.test_reach_goal_within_step_limit()
	suite.test_fail_to_reach_goal_due_to_step_limit()
	suite.test_step_count()  # Új teszt hozzáadása

	print("\nMinden teszt lefutott.")
