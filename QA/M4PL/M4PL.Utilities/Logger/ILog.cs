using System;

namespace M4PL.Utilities.Logger
{
    public interface ILog
    {
        void Critical(string message, Exception ex);
        void Error(string message, Exception ex);
        void Warning(string message);
        void Warning(string message, Exception ex);
        void Info(string message);
        void Trace(string message);
    }
}
