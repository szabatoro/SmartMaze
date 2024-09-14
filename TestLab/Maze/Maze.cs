using System;
using System.ComponentModel;
using System.Reflection;
using System.Security.Principal;
using System.Text;
using System.Windows;
using System.Threading;

namespace SmartMaze
{
    class Maze
    {
        uint Size = 0;
        char[,]? MazeMatrix;

        const char wall = 'I';
        const char way = '.';
        const char tower = 'A';

        (uint, uint) StartCell = (0,0);
        (uint, uint) FinishCell = (0,0);

        //Játékos specifikus -> jöhetne kívülről
        const char Player = 'P';
        (uint, uint) PlayerCoords = (0,0);
        (uint, uint, uint, uint) Directions = (0,0,0,0); // up, down, left, right
        uint Points = 0;

        UInt16 LevelType = 0;

        public void SetLevelType(UInt16 t)
        {
            LevelType = t;
        }


        /* Leírás
         * Ebben a projektmunkában egy 2D-s játékot fogunk lefejleszteni.
         * 


        //Mi lenne ha az elhasznált nyilak és az össz nyilak arányából származna pont???
        //Hogy azon a pályán az adottságaidhoz képest milyen jól teljesítettél?

        //Vagy a megmaradt irányok legyenek a pontok?

        // ----------------------------------------------------------

        /*
            Legyen olyan, hogy bizonyos időközönként újragenerálja a labirintust? 
                és akkor úgy kellene kijutni kb 5  pályán
            Lehetne egy mayás lore-t neki adni
         */


        void FrameAndPlayer()
        {
            MazeMatrix = new char[Size, Size];

            Random PCol = new Random();
            PlayerCoords = (0, (uint)PCol.Next(1, (int)(Size-1)));
            StartCell = PlayerCoords;

            for (uint row = 0; row < Size; row++)
            {
                for (uint col = 0; col < Size; col++)
                {
                    if ((row, col) == PlayerCoords)
                    {
                        MazeMatrix[row, col] = Player;
                    }

                    else if (row == 0 && col == 0           ||
                             row == Size-1 && col == 0      ||
                             row == 0 && col == Size-1      ||
                             row == Size-1 && col == Size-1 )
                    {
                        MazeMatrix[row, col] = tower;
                    }

                    else if (row == 0           ||
                             col == 0           ||
                             row == Size - 1    ||
                             col == Size - 1    )
                    {
                        MazeMatrix[row, col] = wall;
                    }
                    
                    else
                    {
                        MazeMatrix[row, col] = way;
                    }
                }
            }

            //exit
            FinishCell = (Size - 1, (uint)PCol.Next(1, (int)Size - 1));
            MazeMatrix[FinishCell.Item1, FinishCell.Item2] = way;
        }

        void GenerateMaze()
        {
            //recursive division megtweekelve
            //https://yewtu.be/watch?v=Gqgl5AWU-Ro
            //https://yewtu.be/watch?v=N1WtOloN6tc
            //http://weblog.jamisbuck.org/2011/1/12/maze-generation-recursive-division-algorithm
            //https://weblog.jamisbuck.org/2015/1/15/better-recursive-division-algorithm.html


            /* Célszerű rekurzívvá tenni
             * egy random (ver/hor) index ahova kerül a fal (+ 2 luk) -> a kövi határ
             * azon belül újra
             */

            /* pm: random határ, határok: nwall, swall, wwall, ewall -> ezek egyike lesz a random határ boolal eldöntve
             * test: random index, lukak
             * return: (ha túl szűk) -> falak
             */

            /* Body
             * 1. eldönti, hogy vert/hor -> bool
             * 2. ellenőrzi, hogy leteheti e: startcell, finishcell, lukak, és letett falak -> egy indexet ad vissza
             * 3. leteszi + 2 random luk
             * 4. letett fal indexe -> új határ
             * 5. meghívja saját magát az új határokkal
             */


            /* division(nwall, swall, wwall, ewall) -> bool:
             * 
             *      ellenőriz, hogy van e hely: nwall <-> swall || wwall <-> ewall
             *          ha mindkettő -> random
             *          ha csak az egyik -> azt választja
             *          ha egyik se -> return (bool, indexek) -> az "ős függvény" határaig lehet csak menni
             *          
             *      bool orient = random: 0,1
             *      ellenőriz
             *      letesz
             *      
             *      division(új határok egyik oldal)
             *      division(új határok másik oldal)
             */

        }
        

        // ------------------- Tesztek -------------------

        void GenMazeTest1()
        {

        }

        // -----------------------------------------------


        void Print()
        {
            if (LevelType == 1) Console.WriteLine("Starting level.\n");
            else if (LevelType == 2) Console.WriteLine("Ending level.\n");
            else Console.WriteLine("Middle level.\n");

            for (uint i = 0; i < Size; i++)
            {
                for (uint j = 0; j < Size; j++)
                {
                    if ((i, j) == StartCell)
                        Console.BackgroundColor = ConsoleColor.DarkGreen;
                    else if ((i, j) == FinishCell)
                        Console.BackgroundColor = ConsoleColor.DarkRed;
                    else Console.BackgroundColor = ConsoleColor.Black;

                    Console.Write(MazeMatrix[i, j]);
                }         
                Console.WriteLine();
            }

            Console.WriteLine(
                $"\nDirections:\nUp:\t{Directions.Item1}\nDown:\t{Directions.Item2}\nLeft:\t{Directions.Item3}\nRight:\t{Directions.Item4}"
                );

            Console.Write("\nArrows - Move\n\"e\" - exit\n\"g\" - give up\n> ");
        }

        void ControlPlayer(ConsoleKey control)
        {
            (uint row, uint col) = PlayerCoords;
            MazeMatrix[row, col] = way;

            switch (control)
            {
                case ConsoleKey.UpArrow:
                case ConsoleKey.W:
                    {
                        if (row > 0 && MazeMatrix[row - 1, col] != wall && Directions.Item1 > 0)
                        {
                            row--;
                            Directions.Item1--;
                        }
                    }; break;

                case ConsoleKey.DownArrow:
                case ConsoleKey.S:
                    {
                        if (row < Size - 1 && MazeMatrix[row + 1, col] != wall && Directions.Item2 > 0)
                        {
                            row++;
                            Directions.Item2--;
                        }

                    }; break;

                case ConsoleKey.LeftArrow:
                case ConsoleKey.A:
                    {
                        if (col > 0 && MazeMatrix[row, col - 1] != wall && Directions.Item3 > 0)
                        {
                            col--;
                            Directions.Item3--;
                        }
                    }; break;

                case ConsoleKey.RightArrow:
                case ConsoleKey.D:   
                    {
                        if (col < Size - 1 && MazeMatrix[row, col + 1] != wall && Directions.Item4 > 0)
                        {
                            col++;
                            Directions.Item4--;
                        }

                    }; break;
                case ConsoleKey.G: Lose(); break;
            }

            PlayerCoords = (row, col);
            MazeMatrix[row, col] = Player;

            if(PlayerCoords == FinishCell && HasMoves())
            {
                Win();
            } else if (PlayerCoords != FinishCell && !HasMoves())
            {
                Lose();
            }
        }

        bool HasMoves()
        {
            return (Directions.Item1 > 0 || Directions.Item2 > 0 || Directions.Item3 > 0 || Directions.Item4 > 0);
        }

        void Win()
        {
            Console.Clear();
            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("You Won!");
            Console.ForegroundColor = ConsoleColor.White;
            Points += (Directions.Item1 + Directions.Item2 + Directions.Item3 + Directions.Item4) / Size;
            Console.WriteLine($"Your points: {Points}");
            Console.ReadKey();
        }

        void Lose()
        {
            Console.Clear();
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("You Lost!");
            Console.ForegroundColor = ConsoleColor.White;
            Console.ReadKey();
            Environment.Exit(0);
        }

        public uint Play()
        {
            ConsoleKey control;
            do
            { 
                Console.Clear();
                Print();
                control = Console.ReadKey().Key;
                ControlPlayer(control);

            } while (!control.Equals(ConsoleKey.E) && PlayerCoords != FinishCell);
            
            return (PlayerCoords == FinishCell) ? Points : 0;
        }

        public Maze(uint _Size)
        {
            Size = (uint)(_Size * 1.6);
            Directions = (Size + 2, Size + 2, Size + 2, Size + 2);

            FrameAndPlayer();
            //GenerateMaze();
            GenMazeTest1();
        }
    }
}