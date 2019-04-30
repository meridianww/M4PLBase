/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramRoles
//Purpose:                                      End point to interact with Program Role module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ProgramRoles")]
    public class PrgRolesController : BaseApiController<PrgRole>
    {
        private readonly IPrgRoleCommands _programRoleCommands;

        /// <summary>
        /// Function to get Program's Role details
        /// </summary>
        /// <param name="programRoleCommands"></param>
        public PrgRolesController(IPrgRoleCommands programRoleCommands)
            : base(programRoleCommands)
        {
            _programRoleCommands = programRoleCommands;
        }
    }
}