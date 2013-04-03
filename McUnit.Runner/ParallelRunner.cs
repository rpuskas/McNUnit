using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using NUnit.Framework;

namespace McUnit.Runner
{
    public class ParallelRunner
    {
        private readonly int _batchSize = 3;
        private readonly Queue<Type> _queue;
        private readonly List<Task> _tasks;
        private readonly Assembly _assembly;

        public ParallelRunner(int batchSize,string assemblyFile)
        {
            _batchSize = batchSize;
            _assembly = Assembly.LoadFrom(assemblyFile);
            _queue = new Queue<Type>(_assembly.GetTypes().Where(HasFixtureAttribute));
            _tasks = new List<Task>();
        }

        public void Run()
        {
            Console.WriteLine(_assembly.Location);
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            RunAllTests();

            stopwatch.Stop();
            Console.WriteLine(stopwatch.Elapsed);
        }

        private void RunAllTests()
        {
            for (var i = 0; i < _batchSize; i++)
            {
                _tasks.Add(new Task(ProcessNextItem));
            }

            foreach (var task in _tasks)
            {
                task.Start();
            }

            Task.WaitAll(_tasks.ToArray());
        }

        private void ProcessNextItem()
        {
            Type next = null;
            lock(this)
            {
                if(_queue.Count > 0)
                {
                    next = _queue.Dequeue();
                }
            }

            if(next != null)
            {
                Console.WriteLine("Processing item {0}", next);

                NUnit.ConsoleRunner.Runner.Main(new[] { FixtureTypeToNUnitArgument(next), _assembly.Location });        
                
                Console.WriteLine("Processed item {0}", next);
                ProcessNextItem();
            }

        }

        private static string FixtureTypeToNUnitArgument(Type type)
        {
            return string.Format(@"/fixture={0}", type);
        }

        private static bool HasFixtureAttribute(Type type)
        {
            return type.GetCustomAttributes(false).Any(attribute => attribute.GetType() == typeof(TestFixtureAttribute));
        }
    }
}