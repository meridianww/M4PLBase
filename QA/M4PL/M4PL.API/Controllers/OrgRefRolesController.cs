/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizatioRefRole
//Purpose:                                      End point to interact with Organizatio Ref Role module
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/OrgRefRoles")]
    public class OrgRefRolesController : BaseApiController<OrgRefRole>
    {
        private readonly IOrgRefRoleCommands _orgRefRoleCommands;

        /// <summary>
        /// Function to get Organization's ref role details
        /// </summary>
        /// <param name="orgRefRoleCommands"></param>
        public OrgRefRolesController(IOrgRefRoleCommands orgRefRoleCommands)
            : base(orgRefRoleCommands)
        {
            _orgRefRoleCommands = orgRefRoleCommands;
        }
    }
}