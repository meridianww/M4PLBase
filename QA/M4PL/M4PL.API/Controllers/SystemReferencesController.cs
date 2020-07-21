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
//Program Name:                                 SystemReferences
//Purpose:                                      End point to interact with SystemReference module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;


namespace M4PL.API.Controllers
{
    [CustomAuthorize]
    [RoutePrefix("api/SystemReferences")]
    public class SystemReferencesController : ApiController
    {
        private readonly ISystemReferenceCommands _systemReferenceCommands;

        /// <summary>
        /// Function to get Administration's System reference details
        /// </summary>
        /// <param name="systemReferenceCommands"></param>
        public SystemReferencesController(ISystemReferenceCommands systemReferenceCommands)
        {
            _systemReferenceCommands = systemReferenceCommands;
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
        public virtual IQueryable<SystemReference> PagedData(PagedDataInfo pagedDataInfo)
        {
            _systemReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemReferenceCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the systemReference.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual SystemReference Get(long id)
        {
            _systemReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemReferenceCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new systemReference object passed as parameter.
        /// </summary>
        /// <param name="systemReference">Refers to systemReference object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual SystemReference Post(SystemReference systemReference)
        {
            _systemReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemReferenceCommands.Post(systemReference);
        }

        /// <summary>
        /// Put method is used to update record values completely based on systemReference object passed.
        /// </summary>
        /// <param name="systemReference">Refers to systemReference object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual SystemReference Put(SystemReference systemReference)
        {
            _systemReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemReferenceCommands.Put(systemReference);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _systemReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemReferenceCommands.Delete(id);
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
            _systemReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemReferenceCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on systemReference object passed.
        /// </summary>
        /// <param name="systemReference">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual SystemReference Patch(SystemReference systemReference)
        {
            _systemReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemReferenceCommands.Patch(systemReference);
        }
        /// <summary>
        /// Function to get Deleted Records Lookup Ids
        /// </summary>
        /// <param name="allIds"></param>
        [CustomAuthorize]
        [HttpGet]
        [Route("DeletedRecordLookUpIds")]
        public IQueryable<IdRefLangName> GetDeletedRecordLookUpIds(string allIds)
        {
            _systemReferenceCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _systemReferenceCommands.GetDeletedRecordLookUpIds(allIds).AsQueryable();
        }
    }
}