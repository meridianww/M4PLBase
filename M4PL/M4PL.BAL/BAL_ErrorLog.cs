using M4PL.Entities;
using M4PL_API_DAL.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_BAL
{
    public class BAL_ErrorLog
    {
        /// <summary>
        /// Logs the Exception to database
        /// </summary>
        /// <param name="errorLog"></param>
        public static void LogException(LogError errorLog)
        {
            DAL_ErrorLog.LogException(errorLog);
        }
    }
}
