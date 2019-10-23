/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              10/23/2019
Program Name:                                 ErrorLogger
Purpose:                                      Contains commands to perform Error Log
=============================================================================================================*/
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Utilities.Logger;
using System;
using System.Collections.Generic;

namespace M4PL.DataAccess.Logger
{
	public static class ErrorLogger
	{
		public static void Log(Exception exception, string additionlMessage, string errRelatedTo, LogType logType)
		{
			var parameters = GetParameters(exception, additionlMessage, errRelatedTo, logType);
			SqlSerializer.Default.Execute(StoredProceduresConstant.InsErrorLogInfo, parameters.ToArray(), true);
		}

		private static List<Parameter> GetParameters(Exception exception, string additionlMessage, string errRelatedTo, LogType logType)
		{
			var parameters = new List<Parameter>
			{
			   new Parameter("@ErrRelatedTo", errRelatedTo),
			   new Parameter("@ErrInnerException", exception.InnerException),
			   new Parameter("@ErrMessage", exception.Message),
			   new Parameter("@ErrSource", exception.Source),
			   new Parameter("@ErrStackTrace", exception.StackTrace),
			   new Parameter("@ErrAdditionalMessage", additionlMessage),
			   new Parameter("@LogType", logType.ToString())
			};

			return parameters;
		}
	}
}
