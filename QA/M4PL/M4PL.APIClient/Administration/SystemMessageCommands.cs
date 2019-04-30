/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 SystemMessageCommands
Purpose:                                      Client to consume M4PL http://hostname/api/SystemMessages Web API
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    public class SystemMessageCommands : BaseCommands<SystemMessageView>, ISystemMessageCommands
    {
        /// <summary>
        /// Route to call SystemMessages Web API
        /// </summary>
        public override string RouteSuffix
        {
            get { return "SystemMessages"; }
        }
    }
}