
using Antlr4.Runtime;
using System.Text.Json.Serialization;

namespace PlSqlParser
{
    public class PlSqlError(int line, int charPositionInLine, string message, RecognitionException error)
    {
        [JsonIgnore]
        public static List<PlSqlError> Current { get; } = [];

        public int Line { get; } = line;

        public int CharPositionInLine { get; } = charPositionInLine;

        public string Message { get; } = message;

        [JsonIgnore]
        public RecognitionException Error { get; } = error;
    }
}
