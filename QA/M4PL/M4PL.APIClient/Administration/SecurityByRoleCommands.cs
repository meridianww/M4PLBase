/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 SecurityByRoleCommands
Purpose:                                      Client to consume M4PL API called SecurityByRoleController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    public class SecurityByRoleCommands : BaseCommands<SecurityByRoleView>, ISecurityByRoleCommands
    {
        /// <summary>
        /// Route to call SecurityByRoles
        /// </summary>
        public override string RouteSuffix
        {
            get { return "SecurityByRoles"; }
        }
    }
}