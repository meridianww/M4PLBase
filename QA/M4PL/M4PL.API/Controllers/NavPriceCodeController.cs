#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Finance.PriceCode;
using M4PL.Entities.Finance.PriceCode;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using M4PL.API.Filters;
using System.Web.Http.Description;
using M4PL.APIClient.ViewModels.Document;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller For Nav Related Operations
    /// </summary>

    [CustomAuthorize]
    [RoutePrefix("api/NavPriceCode")]
    public class NavPriceCodeController : ApiController
    {
        private readonly INavPriceCodeCommands _navPriceCodeCommands;

        /// <summary>
        /// Initializes a new instance of the <see cref="NavPriceCodeController"/> class.
        /// </summary>
        public NavPriceCodeController(INavPriceCodeCommands navPriceCodeCommands)

        {
            _navPriceCodeCommands = navPriceCodeCommands;
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
        public virtual IQueryable<NavPriceCode> PagedData(PagedDataInfo pagedDataInfo)
        {
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the navPriceCode.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual NavPriceCode Get(long id)
        {
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new navPriceCode object passed as parameter.
        /// </summary>
        /// <param name="navPriceCode">Refers to navPriceCode object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual NavPriceCode Post(NavPriceCode navPriceCode)
        {
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.Post(navPriceCode);
        }

        /// <summary>
        /// Put method is used to update record values completely based on navPriceCode object passed.
        /// </summary>
        /// <param name="navPriceCode">Refers to navPriceCode object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual NavPriceCode Put(NavPriceCode navPriceCode)
        {
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.Put(navPriceCode);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.Delete(id);
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
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on navPriceCode object passed.
        /// </summary>
        /// <param name="navPriceCode">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual NavPriceCode Patch(NavPriceCode navPriceCode)
        {
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.Patch(navPriceCode);
        }
        [HttpGet]
        [Route("GetAllPriceCode")]
        public virtual IList<NavPriceCode> GetAllPriceCode()
        {
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.GetAllPriceCode();
        }
        [HttpGet]
        [Route("GetPriceCodeReportByJobId")]
        public virtual Entities.Document.DocumentData GetPriceCodeReportByJobId(string jobId)
        {
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.GetPriceCodeReportByJobId(jobId);
        }
        [HttpGet]
        [Route("IsPriceCodeDataPresentForJobInNAV")]
        public virtual Entities.Document.DocumentStatus IsPriceCodeDataPresentForJobInNAV(string jobId)
        {
            _navPriceCodeCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navPriceCodeCommands.IsPriceCodeDataPresentForJobInNAV(jobId);
        }
    }
}