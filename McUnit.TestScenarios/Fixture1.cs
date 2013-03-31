using System.Threading;
using NUnit.Framework;

namespace McUnit.TestScenarios
{
    [TestFixture]
    public class Fixture1
    {
        [Test]
        public void TestOneSecond()
        {
            Thread.Sleep(1000);
            Assert.IsTrue(true);
        }
    }

    [TestFixture]
    public class Fixture2
    {
        [Test]
        public void OneSecond()
        {
            Thread.Sleep(1000);
            Assert.IsTrue(true);
        }

        [Test]
        public void TwoSeconds()
        {
            Thread.Sleep(2000);
            Assert.IsTrue(true);
        }
    }

    [TestFixture]
    public class Fixture3
    {
        [Test]
        public void TwoSeconds()
        {
            Thread.Sleep(2000);
            Assert.IsTrue(true);
        }
    }
}
