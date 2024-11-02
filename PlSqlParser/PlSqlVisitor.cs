
using Antlr4.Runtime.Misc;

namespace PlSqlParser
{
    public class PlSqlVisitor : PlSqlParserBaseVisitor<object>
    {
        public override object VisitSql_script([NotNull] PlSqlParser.Sql_scriptContext tree)
        {
            return Traverse(tree);
        }

        public static PlSqlNode Traverse(Antlr4.Runtime.Tree.IParseTree tree, PlSqlNode? parent = null)
        {
            PlSqlNode node = new(tree, parent, []);

            for (int i = 0; i < tree.ChildCount; i++)
                node.Children.Add(Traverse(tree.GetChild(i), node));

            return node;
        }
    }
}
