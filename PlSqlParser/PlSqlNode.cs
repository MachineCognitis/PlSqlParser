
using System.Text.Json.Serialization;

namespace PlSqlParser
{
    public class PlSqlNode
    {
        public PlSqlNode() { }

        public PlSqlNode(Antlr4.Runtime.Tree.IParseTree node, PlSqlNode? parent, List<PlSqlNode> children)
        {
            Context = node.GetType().Name;
            Symbol = Context == "TerminalNodeImpl" ? node.GetText().ToUpperInvariant() : node.GetText();
            Children = children;
            Parent = parent;
            Antlr4.Runtime.IToken? token = node.Payload as Antlr4.Runtime.IToken;
            if (token is not null)
            {
                Line = token.Line;
                StartIndex = token.StartIndex;
                StopIndex = token.StopIndex;
            }
        }

        public string Context { get; set; } = "";

        public string Symbol { get; set; } = "";

        public List<PlSqlNode> Children { get; set; } = [];

        [JsonIgnore]
        public PlSqlNode? Parent { get; set; }

        public int? Line { get; set; }

        public int? StartIndex { get; set; }

        public int? StopIndex { get; set; }

        public void SetParent()
        {
            foreach (PlSqlNode child in Children)
            {
                child.Parent = this;
                child.SetParent();
            }
        }
    }
}
