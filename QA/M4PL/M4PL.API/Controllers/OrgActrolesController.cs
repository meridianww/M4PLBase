/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrgActRoles
//Purpose:                                      End point to interact with Organization Act Roles module
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/OrgActRoles")]
    public class OrgActRolesController : BaseApiController<OrgActRole>
    {
        private readonly IOrgActRoleCommands _orgActRoleCommands;

        /// <summary>
        /// Function to get Organization's Act role details
        /// </summary>
        /// <param name="orgActRoleCommands"></param>
        public OrgActRolesController(IOrgActRoleCommands orgActRoleCommands)
            : base(orgActRoleCommands)
        {
            _orgActRoleCommands = orgActRoleCommands;
        }
    }
}