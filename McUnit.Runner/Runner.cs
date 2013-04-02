using System;
using System.Linq;
using System.Reflection;
using McUnit.TestScenarios;
using NUnit.Framework;

namespace McUnit.Runner
{
    [TestFixture]
    public class Runner
    {
        [Test]
        public void Run()
        {
            var assembly = Assembly.GetAssembly(typeof(Fixture1));
            var types = assembly.GetTypes();
            var fixtures = types.ToList().Where(HasFixtureAttribute);

            foreach (var fixture in fixtures)
            {
                NUnit.ConsoleRunner.Runner.Main(new[] { FixtureTypeToNUnitArgument(fixture), assembly.Location });    
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