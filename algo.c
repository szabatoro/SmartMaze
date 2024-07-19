// ---- Modified Recursive Division ----
// Windows:	gcc -o algo.exe algo.c -s -O3
// Linux:	gcc -o algo algo.c -s -O3

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MIN_MAZE_SIZE		5
#define MAZE_SAFETY_SIZE	3
#define STRETCH_RATIO		2       //mennyire nyújtsa meg a képet
#define KILLSWITCH		100
#define NL			'\n'
#define PATH			0
#define WALL			1

#define PATH_COL	"\033[48;2;56;142;47m\033[38;2;56;142;47m"
#define	WALL_COL	"\033[48;2;99;63;8m\033[38;2;99;63;8m"
#define GREY		"\033[38;2;100;100;100m"
#define DFLT_COL	"\033[0m"

#define HIDE_CURSOR "\033[?25l"
#define SHOW_CURSOR "\033[?25h"

#ifdef _WIN32
#include <windows.h>
void enable_ansi_escseq() {
	HANDLE h_out = GetStdHandle(STD_OUTPUT_HANDLE);
	DWORD dw_mode = 0;
	GetConsoleMode(h_out, &dw_mode);
	dw_mode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
	SetConsoleMode(h_out, dw_mode);
}
void disable_ansi_escseq() {
	HANDLE h_out = GetStdHandle(STD_OUTPUT_HANDLE);
	DWORD dw_mode = 0;
	GetConsoleMode(h_out, &dw_mode);
	dw_mode &= ~ENABLE_VIRTUAL_TERMINAL_PROCESSING;
	SetConsoleMode(h_out, dw_mode);
}
#define ANSI_SEQ_ON enable_ansi_escseq()
#define ANSI_SEQ_OFF disable_ansi_escseq()

#elif __linux__
#define ANSI_SEQ_ON ;
#define ANSI_SEQ_OFF ;
#endif

typedef int** mtx;



void prep_env() {
	ANSI_SEQ_ON;
	srand(time(NULL));
	printf(HIDE_CURSOR);
}

void tidy_env() {
	printf(SHOW_CURSOR);
	ANSI_SEQ_OFF;
}

void enter() {
	while(printf(GREY "<enter>" DFLT_COL), getchar()!=NL);
}

void allocate_maze(mtx* m, int s) {
	*m = (mtx)malloc(s * sizeof(int*));
	for (int i = 0; i < s; i++)
		(*m)[i] = (int*)malloc(s * sizeof(int));
	if (*m == NULL) {
		perror("Failed to allocate memory!\n");
		enter();
	}
}

void deallocate_maze(mtx m, int s) {
	for (int i = 0; i < s; i++)
		free(m[i]);
	free(m);
}

void maze_frame(mtx m, int s) {		//külső falak + ki- és bejárat
	for (int y = 0; y < s; y++) {
		for (int x = 0; x < s; x++)
			if (x == 0 || x == s - 1 || y == 0 || y == s - 1)
				m[x][y] = WALL;
			else m[x][y] = PATH;
	}
	m[1][0] = m[s - 2][s - 1] = PATH;
}

void print_maze(mtx m, int s) {
	for (int y = 0; y < s; y++) {
		for (int x = 0; x < s; x++) {
			switch (m[x][y]) {
			case WALL:	printf(WALL_COL);	break;
			case PATH:	printf(PATH_COL);	break;
			}
			for (int sq = 0; sq < STRETCH_RATIO; sq++)
				printf("%d", m[x][y]);
			printf(DFLT_COL);
		}
		putchar('|');
		for (int x = 0; x < s; x++)
			printf("%d", m[x][y]);
		putchar(NL);
	}
}

//---------------------------------------------------------------------------------------------------------
//-------------------------------------- Modified Recursive Division --------------------------------------
//---------------------------------------------------------------------------------------------------------

int mrandom(int min, int max) {		//itt a min és a max is benne van határokban
	return rand() % (max - min + 1) + min;
}


void make_path(mtx m, int start, int length, int wall_i, int v) {	// letesz egy átjárót egy random helyre
	int path_i = mrandom(start, start + length - 1);		 	// nem nézi meg hogy ott van-e már lyuk, ezért
	(v ? (m[wall_i][path_i] = PATH) : (m[path_i][wall_i] = PATH));	// tehet az előző helyére is és így csak egy lyuk lesz
}


void ModRecDiv(mtx m, int start_x, int end_x, int start_y, int end_y, int v) {
//-----------------------------------------------------------------------------------------------------------	
// kilép, ha túl kicsi a hely
	int hlength = end_x - start_x;		// vizsgálandó terület
	int vlength = end_y - start_y;
	if (hlength <= MAZE_SAFETY_SIZE || vlength <= MAZE_SAFETY_SIZE) return;

//-----------------------------------------------------------------------------------------------------------
// megnézi, hogy hova teheti le a falat;
// ha beakadna egy infinite loopba, a killswitch kidobja onnan
	int wall_i, sbound, ebound, tries = 0;	// fan index, határai, próbálkozások
	do {
		wall_i = v ? mrandom(start_x + 2, end_x - 2) : mrandom(start_y + 2, end_y - 2);
		sbound = v ? m[wall_i][start_y] : m[start_x][wall_i];		//fal határai, hogy lehessen ellenőrizni
		ebound = v ? m[wall_i][end_y] : m[end_x][wall_i];		//-> új fal csak 2 másik fal között helyezkedhet el
		tries++;
	} while ((sbound != WALL || ebound != WALL) && tries < KILLSWITCH);

	if (tries == KILLSWITCH) return;	// ha 100 próbálkozás után sem talál megfelelő indexet, kilép

//-----------------------------------------------------------------------------------------------------------
// leteszi a falat
	for (int y = start_y; y <= end_y; y++)
		for (int x = start_x; x <= end_x; x++)
			v ? (m[wall_i][y] = WALL) : (m[x][wall_i] = WALL);

//-----------------------------------------------------------------------------------------------------------
// letesz 2 lyukat, ha hosszabb 5 egységnél a fal,
// különben csak 1-et
	int start = v ? start_y : start_x;		// honnan induljon
	int length = v ? vlength : hlength;		// meddig menjen
	make_path(m, start + 1, length - 1, wall_i, v);
	if (length > 5) make_path(m, start + 1, length - 1, wall_i, v);
	// ez az utolsó sor teszi ezt megáltoztatott rekurzív elosztássá, ki lehet kommentelni
	// és akkor az eredeti rekurzív elosztást kapjuk

//-----------------------------------------------------------------------------------------------------------
// lekicsinyíti a területet a fal két oldalán és elindul
// mindkét irányba
	int nv = hlength >= vlength;		// new vertical a jelenlegi terület oldalaiból
	int nex_lu = v ? wall_i : end_x;	// new end x - left, up
	int ney_lu = v ? end_y : wall_i;	// new end y - left, up
	int nsx_rd = v ? wall_i : start_x;	// new start x - right, down
	int nsy_rd = v ? start_y : wall_i;	// new start y - right, down
	ModRecDiv(m, start_x, nex_lu, start_y, ney_lu, nv);
	ModRecDiv(m, nsx_rd, end_x, nsy_rd, end_y, nv);
}
//---------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------------------

int main(void) {
	prep_env();
	mtx Maze = NULL;
	int s = 20;

	allocate_maze(&Maze, s);
	maze_frame(Maze, s);
	ModRecDiv(Maze, 0, s - 1, 0, s - 1, 1); //indexelés: 0..s-1
	print_maze(Maze, s);
	deallocate_maze(Maze, s);
    	enter();
   
	tidy_env();
	return EXIT_SUCCESS;
}
