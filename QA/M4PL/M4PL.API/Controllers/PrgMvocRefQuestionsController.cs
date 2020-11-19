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
//Program Name:                                 ProgramMvocRefQuestions
//Purpose:                                      End point to interact with Program Mvoc Ref Questions module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;

namespace M4PL.API.Controllers
{
	/// <summary>
    /// Controller for Program VOC Survey questions
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/PrgMvocRefQuestions")]
    public class PrgMvocRefQuestionsController : ApiController
	{
		private readonly IPrgMvocRefQuestionCommands _mvocRefQuestionCommands;

		/// <summary>
		/// Function to get Program's mvoc ref question details
		/// </summary>
		/// <param name="mvocRefQuestionCommands"></param>
		public PrgMvocRefQuestionsController(IPrgMvocRefQuestionCommands mvocRefQuestionCommands)
			
		{
			_mvocRefQuestionCommands = mvocRefQuestionCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<PrgMvocRefQuestion> PagedData(PagedDataInfo pagedDataInfo)
        {
            _mvocRefQuestionCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _mvocRefQuestionCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the prgMvocRefQuestion.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual PrgMvocRefQuestion Get(long id)
        {
            _mvocRefQuestionCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _mvocRefQuestionCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new prgMvocRefQuestion object passed as parameter.
        /// </summary>
        /// <param name="prgMvocRefQuestion">Refers to prgMvocRefQuestion object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual PrgMvocRefQuestion Post(PrgMvocRefQuestion prgMvocRefQuestion)
        {
            _mvocRefQuestionCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _mvocRefQuestionCommands.Post(prgMvocRefQuestion);
        }

        /// <summary>
        /// Put method is used to update record values completely based on prgMvocRefQuestion object passed.
        /// </summary>
        /// <param name="prgMvocRefQuestion">Refers to prgMvocRefQuestion object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual PrgMvocRefQuestion Put(PrgMvocRefQuestion prgMvocRefQuestion)
        {
            _mvocRefQuestionCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _mvocRefQuestionCommands.Put(prgMvocRefQuestion);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _mvocRefQuestionCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _mvocRefQuestionCommands.Delete(id);
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
            _mvocRefQuestionCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _mvocRefQuestionCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on prgMvocRefQuestion object passed.
        /// </summary>
        /// <param name="prgMvocRefQuestion">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual PrgMvocRefQuestion Patch(PrgMvocRefQuestion prgMvocRefQuestion)
        {
            _mvocRefQuestionCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _mvocRefQuestionCommands.Patch(prgMvocRefQuestion);
        }
    }
}