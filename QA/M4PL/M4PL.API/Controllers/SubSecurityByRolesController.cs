/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 SubSecurityByRoles
//Purpose:                                      End point to interact with SubSecurityByRole module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/SubSecurityByRoles")]
    public class SubSecurityByRolesController : BaseApiController<SubSecurityByRole>
    {
        private readonly ISubSecurityByRoleCommands _subSecurityByRoleCommands;

        /// <summary>
        /// Fucntion to get Organization's Actroles -subsecurity details
        /// </summary>
        /// <param name="subSecurityByRoleCommands"></param>
        public SubSecurityByRolesController(ISubSecurityByRoleCommands subSecurityByRoleCommands)
            : base(subSecurityByRoleCommands)
        {
            _subSecurityByRoleCommands = subSecurityByRoleCommands;
        }
    }
}