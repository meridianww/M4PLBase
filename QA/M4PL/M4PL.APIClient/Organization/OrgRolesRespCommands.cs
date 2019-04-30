/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 OrgRolesRespCommands
Purpose:                                      Client to consume M4PL API called OrgRolesRespController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Organization;

namespace M4PL.APIClient.Organization
{
    public class OrgRolesRespCommands : BaseCommands<OrgRolesRespView>, IOrgRolesRespCommands
    {
        /// <summary>
        /// Route to call OrgActRoles
        /// </summary>
        public override string RouteSuffix
        {
            get { return "OrgActRoles"; }
        }
    }
}
