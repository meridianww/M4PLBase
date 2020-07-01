/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 JobAttributeCommands
Purpose:                                      Client to consume M4PL API called JobAttributeController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
    public class JobAttributeCommands : BaseCommands<JobAttributeView>, IJobAttributeCommands
    {
        /// <summary>
        /// Route to call JobAttributes
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobAttributes"; }
        }
    }
}