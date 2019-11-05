/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              25/07/2019
Program Name:                                 IJobBillableSheetCommands
Purpose:                                      Set of rules for JobBillableSheetCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities.Job;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient.Job
{
    public interface IJobBillableSheetCommands : IBaseCommands<JobBillableSheetView>
    {
		IList<JobPriceCodeAction> GetJobPriceCodeAction(long jobId);

		JobBillableSheetView GetJobPriceCodeByProgram(long id, long jobId);
	}
}
