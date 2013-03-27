using NUnit.Framework;

namespace McUnit.TestScenarios
{
    [TestFixture]
    public class SimpleTestScenario
    {
        [Test]
        public void ASimpleTest()
        {
            Assert.IsTrue(true);
        }
    }
}
