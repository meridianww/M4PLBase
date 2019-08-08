/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              26/07/2019
Program Name:                                 JobBillableSheetCommands
Purpose:                                      Client to consume M4PL API called JobBillableSheetController
=================================================================================================================*/
using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{

    public class JobBillableSheetCommands : BaseCommands<JobBillableSheetView>, IJobBillableSheetCommands
    {
        /// <summary>
        /// Route to call JobBillableSheets
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobBillableSheets"; }
        }
    }
}
