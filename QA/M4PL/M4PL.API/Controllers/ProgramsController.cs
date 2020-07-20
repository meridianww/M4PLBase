#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 Programs
//Purpose:                                      End point to interact with Program module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [CustomAuthorize]
    [RoutePrefix("api/Programs")]
	public class ProgramsController : ApiController
	{
		private readonly IProgramCommands _programCommands;

		/// <summary>
		/// Function to get program details
		/// </summary>
		/// <param name="programCommands"></param>
		public ProgramsController(IProgramCommands programCommands)
			
		{
			_programCommands = programCommands;
		}

        /// <summary>
        /// PagedData method is used to get limited recordset with Total count based on pagedDataInfo values.
        /// </summary>
        /// <param name="pagedDataInfo">
        /// This parameter require field values like PageNumber,PageSize,OrderBy,GroupBy,GroupByWhereCondition,WhereCondition,IsNext,IsEnd etc.
        /// </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<Program> PagedData(PagedDataInfo pagedDataInfo)
        {
            _programCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _programCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the program.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual Program Get(long id)
        {
            _programCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _programCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new program object passed as parameter.
        /// </summary>
        /// <param name="program">Refers to program object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual Program Post(Program program)
        {
            _programCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _programCommands.Post(program);
        }

        /// <summary>
        /// Put method is used to update record values completely based on program object passed.
        /// </summary>
        /// <param name="program">Refers to program object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual Program Put(Program program)
        {
            _programCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _programCommands.Put(program);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _programCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _programCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList method is used to delete a multiple records for ids passed as comma seprated list of string.
        /// </summary>
        /// <param name="ids">Refers to comma seprated ids as string.</param>
        /// <param name="statusId">Refers to numeric value, It can have value 3 to make record archive.</param>
        /// <returns>Returns response as list of IdRefLangName objects.</returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _programCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _programCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on program object passed.
        /// </summary>
        /// <param name="program">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual Program Patch(Program program)
        {
            _programCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _programCommands.Patch(program);
        }
        /// <summary>
        /// ProgramTree
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="isCustNode"></param>
        /// <returns></returns>
        [CustomAuthorize]
		[HttpGet]
		[Route("ProgramTree")]
		public virtual IQueryable<TreeModel> ProgramTree(long? parentId, bool isCustNode)
		{
			return _programCommands.ProgramTree(Models.ApiContext.ActiveUser, Models.ApiContext.ActiveUser.OrganizationId, parentId, isCustNode).AsQueryable(); ;
		}

		[CustomAuthorize]
		[HttpGet]
		[Route("GetProgram")]
		public Program GetProgram(long id, long? parentId)
		{
			return _programCommands.GetProgram(Models.ApiContext.ActiveUser, id, parentId);
		}

		[CustomAuthorize]
		[HttpGet]
		[Route("ProgramCopyTree")]
		public virtual IQueryable<TreeModel> ProgramCopyTree(long programId, long? parentId, bool isCustNode, bool isSource)
		{
			return _programCommands.ProgramCopyTree(Models.ApiContext.ActiveUser, programId, parentId, isCustNode, isSource).AsQueryable(); ;
		}

		[CustomAuthorize]
		[HttpPost]
		[Route("CopyPPPModel")]
		public async Task<bool> CopyPPPModel(CopyPPPModel copyPPPMopdel)
		{
			var output = await Task.Run(() => _programCommands.CopyPPPModel(copyPPPMopdel, Models.ApiContext.ActiveUser));
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