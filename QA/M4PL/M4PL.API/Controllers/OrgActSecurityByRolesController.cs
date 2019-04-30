/*Copyright (2018) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              04/16/2018
//Program Name:                                 OrgActSecurityByRoles
//Purpose:                                      End point to interact with OrgActSecurityByRole module
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/OrgActSecurityByRoles")]
    public class OrgActSecurityByRolesController : BaseApiController<OrgActSecurityByRole>
    {
        private readonly IOrgActSecurityByRoleCommands _OrgActSecurityByRoleCommands;

        /// <summary>
        /// Fucntion to get OrgActSecurityByRoles details
        /// </summary>
        /// <param name="OrgActSecurityByRoleCommands"></param>
        public OrgActSecurityByRolesController(IOrgActSecurityByRoleCommands OrgActSecurityByRoleCommands)
            : base(OrgActSecurityByRoleCommands)
        {
            _OrgActSecurityByRoleCommands = OrgActSecurityByRoleCommands;
        }
    }
}