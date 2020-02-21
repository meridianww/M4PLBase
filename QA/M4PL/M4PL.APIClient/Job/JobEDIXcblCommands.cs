﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                 Prashant Aggarwal
//Date Programmed:                            19/02/2020
Program Name:                                 JobEDIXcblCommands
Purpose:                                      Client to consume M4PL API called JobEDIXcblController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
    public class JobEDIXcblCommands : BaseCommands<JobEDIXcblView>, IJobEDIXcblCommands
	{
		/// <summary>
		/// Route to call JobEDIXcbl
		/// </summary>
		public override string RouteSuffix
        {
            get { return "JobEDIXcbl"; }
        }
    }
}