using M4PL.DataAccess.Serializer;
using M4PL.Entities;
using M4PL_API_CommonUtils;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_API_DAL.DAL
{
    public class DAL_ErrorLog
    {
        /// <summary>
        /// This method logs the data in the database
        /// </summary>
        /// <param name="log">The exception details to log</param>
        public static void LogException(LogError log)
        {
            try
            {
                var param = new Parameter[]
				{
					new Parameter("@Source", log.Source),
					new Parameter("@Message", log.Message),
					new Parameter("@StackTrace", log.StackTrace),
					new Parameter("@UserName", log.UserName),
					new Parameter("@ApplicationUrl", log.ApplicationUrl),
				};

                SqlSerializer.Default.Execute(StoredProcedureNames.InsertErrorLog, param, true);
            }
            catch (Exception)
            {
                // the only case that can happen is Database connection is not valid
                // TODO: log in the file section
            }
        }

    }
}
