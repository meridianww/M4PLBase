/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 SubSecurityByRoleCommands
Purpose:                                      Client to consume M4PL API called SubSecurityByRoleController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    public class SubSecurityByRoleCommands : BaseCommands<SubSecurityByRoleView>, ISubSecurityByRoleCommands
    {
        /// <summary>
        /// Route to call SubSecurityByRoles
        /// </summary>
        public override string RouteSuffix
        {
            get { return "SubSecurityByRoles"; }
        }
    }
}