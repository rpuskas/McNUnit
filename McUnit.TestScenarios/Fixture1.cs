using NUnit.Framework;

namespace McUnit.TestScenarios
{
    static internal class CpuConsumer
    {
        public static void For(int seconds)
        {
            var stopped = false;
            var timer = new System.Timers.Timer(seconds * 1000);
            timer.Elapsed += (s, e) => stopped = true;
            timer.Start();

            while (!stopped) { } //eat them all
        }
    }

    [TestFixture]
    public class Fixture1
    {
        [Test]
        public void One()
        {
            CpuConsumer.For(5);
            Assert.IsTrue(true);
        }
    }

    [TestFixture]
    public class Fixture2
    {
        [Test]
        public void One()
        {
            CpuConsumer.For(5);
            Assert.IsTrue(true);
        }

        [Test]
        public void Two()
        {
            CpuConsumer.For(5);
            Assert.IsTrue(true);
        }
    }

    [TestFixture]
    public class Fixture3
    {
        [Test]
        public void One()
        {
            CpuConsumer.For(10); 
            Assert.IsTrue(true);
        }
    }
}
