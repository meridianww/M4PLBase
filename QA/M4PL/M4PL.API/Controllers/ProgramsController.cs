/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Programs
//Purpose:                                      End point to interact with Program module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/Programs")]
    public class ProgramsController : BaseApiController<Program>
    {
        private readonly IProgramCommands _programCommands;

        /// <summary>
        /// Function to get program details
        /// </summary>
        /// <param name="programCommands"></param>
        public ProgramsController(IProgramCommands programCommands)
            : base(programCommands)
        {
            _programCommands = programCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("ProgramTree")]
        public virtual IQueryable<TreeModel> ProgramTree(long? parentId, bool isCustNode)
        {
            return _programCommands.ProgramTree(ActiveUser, ActiveUser.OrganizationId, parentId, isCustNode).AsQueryable(); ;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GetProgram")]
        public Program GetProgram(long id, long? parentId)
        {
            return _programCommands.GetProgram(ActiveUser, id, parentId);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("ProgramCopyTree")]
        public virtual IQueryable<TreeModel> ProgramCopyTree(long programId, long? parentId, bool isCustNode, bool isSource)
        {
            return _programCommands.ProgramCopyTree(ActiveUser, programId, parentId, isCustNode, isSource).AsQueryable(); ;
        }

        [CustomAuthorize]
        [HttpPost]
        [Route("CopyPPPModel")]
        public async Task<bool> CopyPPPModel(CopyPPPModel copyPPPMopdel)
        {
            var output = await Task.Run(() => _programCommands.CopyPPPModel(copyPPPMopdel, ActiveUser));
            return output;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GetProgramsByCustomer")]
        public List<Entities.Program.Program> GetProgramsByCustomer(long custId)
        {
            return _programCommands.GetProgramsByCustomer(custId);

        }

    }
}