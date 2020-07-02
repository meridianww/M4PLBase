#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System;
using System.Net.Http;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Web;

namespace M4PL.Utilities.Logger
{
    /// <summary>
    /// This class is used to log the exception and information as well.
    /// </summary>
    public class Logger : ILog
    {
        internal System.Diagnostics.TraceSource TraceSource { get; private set; }
        internal bool LogVerbose { get; private set; }
        public Logger(string sourceName, bool logVerbose)
        {
            InitializeTraceSource(sourceName);
            LogVerbose = logVerbose;
        }

        public Logger()
            : this("LoggerTraceSource", false)
        {
        }

        public void Critical(string message, Exception ex)
        {
            Write(LogType.Critical, message, Assembly.GetCallingAssembly(), ex);
        }

        public void Error(string message, Exception ex)
        {
            Write(LogType.Error, message, Assembly.GetCallingAssembly(), ex);
        }

        public void Warning(string message)
        {
            Write(LogType.Warning, message, Assembly.GetCallingAssembly());
        }

        public void Warning(string message, Exception ex)
        {
            Write(LogType.Warning, message, Assembly.GetCallingAssembly(), ex);
        }

        public void Info(string message)
        {
            Write(LogType.Informational, message, Assembly.GetCallingAssembly());
        }

        public void Trace(string message)
        {
            Write(LogType.Trace, message, Assembly.GetCallingAssembly());
        }

        #region Private Methods

        private void Write(LogType level, string message, Assembly callingAssembly = null, Exception exception = null)
        {
            try
            {
                string userName = null;

                if (Thread.CurrentPrincipal != null)
                {
                    userName = Thread.CurrentPrincipal.Identity.Name;
                }

                string routeChain = string.Empty;
                string correlationId = string.Empty;
                string postData = string.Empty;
                string queryString = string.Empty;
                string callingAssemblyName = (callingAssembly ?? Assembly.GetCallingAssembly()).FullName;

                GetVerbose(ref routeChain, ref correlationId, ref postData, ref queryString);

                LogEntry entry = new LogEntry
                {
                    TraceSource = TraceSource.Name,
                    LoggingAssembly = callingAssemblyName,
                    ExceptionMessage = exception == null ? string.Empty : GetExceptionMessage(exception),
                    StackTrace = exception == null ? string.Empty : GetStackTrace(exception),
                    SourceClass = exception == null ? string.Empty : exception.Source ?? "Inner Exception",
                    LogType = level,
                    LogTime = DateTime.Now,
                    AdditionalMessage = message,
                    MachineName = Environment.MachineName,
                    CorrelationId = correlationId,
                    RouteChain = routeChain,
                    PostData = postData,
                    QueryString = queryString,
                    UserName = userName,
                };

                TraceSource.TraceData(entry.TraceEventType, 0, entry);
            }
            catch { }
        }

        private void InitializeTraceSource(string sourceName)
        {
            if (!String.IsNullOrEmpty(sourceName) && !sourceName.Equals("LoggerTraceSource"))
            {
                TraceSource = new System.Diagnostics.TraceSource(sourceName);

                if (TraceSource.Listeners.Count == 1
                    && TraceSource.Listeners[0].GetType().Equals(typeof(System.Diagnostics.DefaultTraceListener)))
                {
                    TraceSource.Close();
                    TraceSource = new System.Diagnostics.TraceSource("LoggerTraceSource");
                }
            }
            else
            {
                TraceSource = new System.Diagnostics.TraceSource("LoggerTraceSource");
            }
        }

        private static string GetBody(HttpRequestMessage request)
        {
            try
            {
                var content = request.Content;
                string jsonContent = content.ReadAsStringAsync().Result;
                return jsonContent;
            }
            catch
            {
                return string.Empty;
            }
        }

        private static string GetQueryString(HttpRequestMessage request)
        {
            string value = string.Empty;
            if (request != null)
            {
                string url = request.RequestUri.ToString();
                string[] values = url.Split('?');
                if (values.Length > 1)
                    return values[1];
            }

            return value;
        }

        private static string GetStackTrace(Exception exception)
        {
            StringBuilder stringBuilder = new StringBuilder();
            Exception innerException = exception;

            do
            {
                stringBuilder.AppendLine(innerException.StackTrace + "  -->  ").AppendLine("------END INNER STACK TRACE------");
                innerException = innerException.InnerException;
            } while (innerException != null);

            return stringBuilder.ToString();
        }

        /// <summary>
        /// Gets the exception message.
        /// </summary>
        /// <param name="exception">The exception.</param>
        /// <returns></returns>
        private static string GetExceptionMessage(Exception exception)
        {
            StringBuilder stringBuilder = new StringBuilder();
            Exception innerException = exception;

            do
            {
                stringBuilder.Append(innerException.Message + "  -->  ");
                innerException = innerException.InnerException;
            } while (innerException != null);

            return stringBuilder.ToString();
        }

        private void GetVerbose(ref string routeChain, ref string correlationId, ref string postData, ref string queryString)
        {
            try
            {
                HttpRequestMessage httpRequestMessage = HttpContext.Current != null ?
                    HttpContext.Current.Items["MS_HttpRequestMessage"] as HttpRequestMessage :
                    null;

                if (httpRequestMessage != null)
                {
                    routeChain = httpRequestMessage.GetHeader(CustomHeaders.RouteChain);
                    correlationId = httpRequestMessage.GetHeader(CustomHeaders.CorrelationId);
                    queryString = LogVerbose ? GetQueryString(httpRequestMessage) : string.Empty;
                    postData = LogVerbose ? GetBody(httpRequestMessage) : string.Empty;
                }
            }
            catch
            {
            }
        }

        #endregion Private Methods
    }
}
