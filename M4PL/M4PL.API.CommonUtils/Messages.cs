using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_API_CommonUtils
{
    public class Messages
    {
        public string Message { get; set; }
        public string Issue { get; set; }
        public MessageTypes MessageType { get; set; }
    }

    public enum MessageTypes
    {
        Success = 1,
        Failure = 2,
        Exception = 3,
        Duplicate = 4,
        ForeignKeyIssue = 5
    };
}
