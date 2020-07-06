#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Diagnostics;

namespace M4PL.Utilities.Logger
{
    public abstract class M4PLTraceListener : TraceListener
    {
        public override void TraceData(TraceEventCache eventCache, string source, TraceEventType eventType, int id, object data)
        {
            Write(data);
        }

        #region WriteLine Implementations

        public override void WriteLine(string message)
        {
            Write(message);
        }

        public override void WriteLine(string message, string category)
        {
            Write(message, category);
        }

        public override void WriteLine(object o)
        {
            Write(o);
        }

        public override void WriteLine(object o, string category)
        {
            Write(o, category);
        }

        #endregion WriteLine Implementations

        #region Write Overloads

        public override void Write(string message)
        {
            Write(new { AdditionalMessage = message });
        }

        public override void Write(string message, string category)
        {
            Write(new { AdditionalMessage = message, ExceptionMessage = category });
        }

        public override void Write(object o, string category)
        {
            Write(o);
        }

        #endregion Write Overloads

        /// <summary>
        /// Write
        /// </summary>
        /// <param name="o"></param>
        //public abstract void Write(object o);
    }
}
