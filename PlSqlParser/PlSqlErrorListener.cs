
using Antlr4.Runtime;

namespace PlSqlParser
{
    public class PlSqlErrorListener : IAntlrErrorListener<IToken>
    {
        public void SyntaxError(TextWriter output, IRecognizer recognizer, IToken offendingSymbol, int line, int charPositionInLine, string msg, RecognitionException e)
        {
            PlSqlError.Current.Add(new PlSqlError(line, charPositionInLine, msg, e));
        }
    }
}
