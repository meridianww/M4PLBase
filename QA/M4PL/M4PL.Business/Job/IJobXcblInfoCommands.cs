/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                 Prashant Aggarwal
//Date Programmed:                            19/02/2020
Program Name:                                 IJobEDIXcblCommands
Purpose:                                      Set of rules for JobEDIXcblCommands
=============================================================================================================*/

using M4PL.Entities.Job;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
	/// <summary>
	/// Performs basic CRUD operation on the JobEDIXcbl Entity
	/// </summary>
	public interface IJobXcblInfoCommands : IBaseCommands<JobXcblInfo>
	{
		JobXcblInfo GetJobXcblInfo(long jobId, long gatewayId);
        bool AcceptJobXcblInfo(JobXcblInfo jobXcblInfoView);
        bool RejectJobXcblInfo(long gatewayId);
    }
}