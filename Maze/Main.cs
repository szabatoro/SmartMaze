using System;
using System.Collections.Generic;

namespace SmartMaze
{
    class MainClass
    {

        static void MakeLevels(ref List<Maze> l, int Size)
        {
            uint size = (Size%2==1) ? (uint)Size+5 : (uint)Size + 6;    //hogy mindig páratlan legyen, de mindig a Size alá csekkol

            for (uint i = 0; i < Size; i++)
            {
                Maze n = new Maze(size + ((i % 2 == 1) ? i : i + 1));
                
                if (i == 0)             n.SetLevelType(1);
                else if (i == Size-1)   n.SetLevelType(2);
                else                    n.SetLevelType(0);

                l.Add(n);
            }

            //15-től generál pályákat, mindegyik 5-tel nagyobb
        }

        static void Main()
        {
            int AmountOfLevels = 1;
            List<Maze> Levels = new List<Maze>(AmountOfLevels);
            MakeLevels(ref Levels, AmountOfLevels);

            uint points = 0;

            foreach(Maze maze in Levels)
            {
                points = maze.Play();
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine($"\nGame finished!\n\nYour Points: {points}");
            Console.ForegroundColor = ConsoleColor.White;
        }
    }
}