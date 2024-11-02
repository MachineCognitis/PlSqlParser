
using Antlr4.Runtime;

namespace PlSqlParser
{
    public static class PlSqlCodeParser
    {
        public static PlSqlNode? Parse(string plSqlText)
        {
            AntlrInputStream inputStream = new(plSqlText);
            PlSqlLexer lexer = new(inputStream);
            CommonTokenStream tokens = new(lexer);
            PlSqlParser parser = new(tokens);
            parser.AddErrorListener(new PlSqlErrorListener());

            PlSqlParser.Sql_scriptContext context = parser.sql_script();
            PlSqlVisitor visitor = new();

            return (PlSqlNode?)visitor.Visit(context);
        }

    }
}
