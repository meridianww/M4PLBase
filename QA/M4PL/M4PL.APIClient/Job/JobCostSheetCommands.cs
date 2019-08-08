/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              25/07/2019
Program Name:                                 JobCostSheetCommands
Purpose:                                      Client to consume M4PL API called JobCostSheetController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
    public class JobCostSheetCommands : BaseCommands<JobCostSheetView>, IJobCostSheetCommands
    {
        /// <summary>
        /// Route to call JobCostSheet
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobCostSheets"; }
        }
    }
}