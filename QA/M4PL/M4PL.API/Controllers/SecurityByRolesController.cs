/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 SecurityByRoles
//Purpose:                                      End point to interact with SecurityByRole module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/SecurityByRoles")]
    public class SecurityByRolesController : BaseApiController<SecurityByRole>
    {
        private readonly ISecurityByRoleCommands _securityByRoleCommands;

        /// <summary>
        /// Fucntion to get SecurityByRoles details
        /// </summary>
        /// <param name="securityByRoleCommands"></param>
        public SecurityByRolesController(ISecurityByRoleCommands securityByRoleCommands)
            : base(securityByRoleCommands)
        {
            _securityByRoleCommands = securityByRoleCommands;
        }
    }
}