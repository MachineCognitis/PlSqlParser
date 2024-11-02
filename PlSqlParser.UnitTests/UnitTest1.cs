using System.Text.Json;

namespace PlSqlParser.UnitTests
{
    [TestClass]
    public class UnitTest1
    {
        private static JsonSerializerOptions Options = new() { MaxDepth = int.MaxValue, WriteIndented = true };

        [TestMethod]
        public void TestParseSqlCode1()
        {
            string plSqlCode = File.ReadAllText("plsql1.pls");
            PlSqlNode? plSqlCodeAST = PlSqlCodeParser.Parse(plSqlCode);
            Assert.IsTrue(PlSqlError.Current.Count == 0);
            string plSqlCodeASTJson = JsonSerializer.Serialize(plSqlCodeAST, Options);
            Assert.IsTrue(plSqlCodeASTJson == File.ReadAllText("PlSql1AST.json"));
        }

        [TestMethod]
        public void TestParseSqlCode2()
        {
            string plSqlCode = File.ReadAllText("plsql2.pls");
            PlSqlNode? plSqlCodeAST = PlSqlCodeParser.Parse(plSqlCode);
            Assert.IsTrue(PlSqlError.Current.Count == 0);
            string plSqlCodeASTJson = JsonSerializer.Serialize(plSqlCodeAST, Options);
            Assert.IsTrue(plSqlCodeASTJson == File.ReadAllText("PlSql2AST.json"));
        }
    }
}