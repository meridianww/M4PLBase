/*Copyright (2018) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              04/16/2018
//Program Name:                                 OrgActSubSecurityByRoles
//Purpose:                                      End point to interact with OrgActSubSecurityByRole module
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/OrgActSubSecurityByRoles")]
    public class OrgActSubSecurityByRolesController : BaseApiController<OrgActSubSecurityByRole>
    {
        private readonly IOrgActSubSecurityByRoleCommands _OrgActSubSecurityByRoleCommands;

        /// <summary>
        /// Fucntion to get Organization's Actroles -subsecurity details
        /// </summary>
        /// <param name="OrgActSubSecurityByRoleCommands"></param>
        public OrgActSubSecurityByRolesController(IOrgActSubSecurityByRoleCommands OrgActSubSecurityByRoleCommands)
            : base(OrgActSubSecurityByRoleCommands)
        {
            _OrgActSubSecurityByRoleCommands = OrgActSubSecurityByRoleCommands;
        }
    }
}