using System;
using System.Diagnostics;

namespace M4PL.Utilities.Logger
{
    public class LogEntry
    {
        public long? LogId { get; set; }

        public string TraceSource { get; set; }

        public string LoggingAssembly { get; set; }

        public string SourceAssembly { get; set; }

        public string ExceptionMessage { get; set; }

        public string StackTrace { get; set; }

        public string SourceClass { get; set; }

        public LogType LogType { get; set; }

        public DateTime LogTime { get; set; }

        public string AdditionalMessage { get; set; }

        public string MachineName { get; set; }

        public string CorrelationId { get; set; }

        public string RouteChain { get; set; }

        public string PostData { get; set; }

        public string QueryString { get; set; }

        public TraceEventType TraceEventType
        {
            get
            {
                switch (LogType)
                {
                    case LogType.Critical:
                        return TraceEventType.Critical;

                    case LogType.Error:
                        return TraceEventType.Error;

                    case LogType.Warning:
                        return TraceEventType.Warning;

                    case LogType.Informational:
                        return TraceEventType.Information;

                    default:
                        return TraceEventType.Verbose;
                }
            }
        }

        public string UserName { get; set; }
    }
}
