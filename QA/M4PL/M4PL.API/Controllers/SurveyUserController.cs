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
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              09/11/2019
//Program Name:                                 JobSurvey
//Purpose:                                      End point to interact with Survey module
//====================================================================================================================================================*/

using M4PL.Business.Survey;
using M4PL.Entities.Survey;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Job Survey Controller
    /// </summary>
    [AllowAnonymous]
    [RoutePrefix("api/SurveyUser")]
    public class SurveyUserController : ApiController
    {
        private readonly ISurveyUserCommands _surveyUserCommands;

        /// <summary>
        /// Function to get the Contact details
        /// </summary>
        /// <param name="surveyUserCommands">surveyUserCommands</param>
        public SurveyUserController(ISurveyUserCommands surveyUserCommands)
        {
            _surveyUserCommands = surveyUserCommands;
        }

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<SurveyUser> PagedData(PagedDataInfo pagedDataInfo)
        {
            _surveyUserCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _surveyUserCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the surveyUser.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual SurveyUser Get(long id)
        {
            _surveyUserCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _surveyUserCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new surveyUser object passed as parameter.
        /// </summary>
        /// <param name="surveyUser">Refers to surveyUser object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual SurveyUser Post(SurveyUser surveyUser)
        {
            _surveyUserCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _surveyUserCommands.Post(surveyUser);
        }

        /// <summary>
        /// Put method is used to update record values completely based on surveyUser object passed.
        /// </summary>
        /// <param name="surveyUser">Refers to surveyUser object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual SurveyUser Put(SurveyUser surveyUser)
        {
            _surveyUserCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _surveyUserCommands.Put(surveyUser);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _surveyUserCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _surveyUserCommands.Delete(id);
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
            _surveyUserCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _surveyUserCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on surveyUser object passed.
        /// </summary>
        /// <param name="surveyUser">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual SurveyUser Patch(SurveyUser surveyUser)
        {
            _surveyUserCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _surveyUserCommands.Patch(surveyUser);
        }

        //      /// <summary>
        //      /// Function to Add the Survey User
        //      /// </summary>
        //      /// <param name="surveyUser"></param>
        //      public override SurveyUser Post(SurveyUser surveyUser)
        //{
        //	return _surveyUserCommands.Post(surveyUser);
        //}

        ///// <summary>
        ///// Function to update the Survey User
        ///// </summary>
        ///// <param name="surveyUser"></param>
        //public override SurveyUser Put(SurveyUser surveyUser)
        //{
        //	return _surveyUserCommands.Put(surveyUser);
        //}
    }
}