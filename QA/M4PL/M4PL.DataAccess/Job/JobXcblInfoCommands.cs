/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                 Prashant Aggarwal
//Date Programmed:                            19/02/2020
Program Name:                                 JobEDIXcblCommands
Purpose:                                      Contains commands to perform CRUD on JobEDIXcbl
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System;

namespace M4PL.DataAccess.Job
{
	public class JobXcblInfoCommands : BaseCommands<JobXcblInfo>
	{
		public static List<JobXcblInfo> GetJobXcblInfo(ActiveUser activeUser, long jobId, string gwyCode, string customerSalesOrder)
		{
			return new List<JobXcblInfo>() {new JobXcblInfo() { ColumnName = "Test", ExistingValue = "123", UpdatedValue = "245" }};
		}
	}
}