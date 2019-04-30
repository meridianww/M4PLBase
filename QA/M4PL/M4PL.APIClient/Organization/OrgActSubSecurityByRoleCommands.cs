/*Copyright(2018) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              04/16/2018
Program Name:                                 OrgActSubSecurityByRoleeCommands
Purpose:                                      Client to consume M4PL API called OrgActSubSecurityByRoleeController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Organization;

namespace M4PL.APIClient.Organization
{
    public class OrgActSubSecurityByRoleCommands : BaseCommands<OrgActSubSecurityByRoleView>, IOrgActSubSecurityByRoleCommands
    {
        /// <summary>
        /// Route to call OrgActSubSecurityByRolees
        /// </summary>
        public override string RouteSuffix
        {
            get { return "OrgActSubSecurityByRoles"; }
        }
    }
}