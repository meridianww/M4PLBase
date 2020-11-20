#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.Finance.SalesOrder;
using M4PL.Entities.Finance;
using M4PL.Entities.Finance.SalesOrder;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller For Sales Order Nav Related Operations
    /// </summary>
    [CustomAuthorize]
    [RoutePrefix("api/NavSalesOrder")]
	public class NavSalesOrderController : ApiController
	{
		private readonly INavSalesOrderCommands _navSalesOrderCommands;

		/// <summary>
		/// Initializes a new instance of the <see cref="NavSalesOrderController"/> class.
		/// </summary>
		public NavSalesOrderController(INavSalesOrderCommands navSalesOrderCommands)

		{
			_navSalesOrderCommands = navSalesOrderCommands;
		}

        /// <summary>Gets the Page Data(RecordSet) to feed the DataGrid</summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<NavSalesOrder> PagedData(PagedDataInfo pagedDataInfo)
        {
            _navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navSalesOrderCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the navSalesOrder.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual NavSalesOrder Get(long id)
        {
            _navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navSalesOrderCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new navSalesOrder object passed as parameter.
        /// </summary>
        /// <param name="navSalesOrder">Refers to navSalesOrder object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual NavSalesOrder Post(NavSalesOrder navSalesOrder)
        {
            _navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navSalesOrderCommands.Post(navSalesOrder);
        }

        /// <summary>
        /// Put method is used to update record values completely based on navSalesOrder object passed.
        /// </summary>
        /// <param name="navSalesOrder">Refers to navSalesOrder object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual NavSalesOrder Put(NavSalesOrder navSalesOrder)
        {
            _navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navSalesOrderCommands.Put(navSalesOrder);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navSalesOrderCommands.Delete(id);
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
            _navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navSalesOrderCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on navSalesOrder object passed.
        /// </summary>
        /// <param name="navSalesOrder">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual NavSalesOrder Patch(NavSalesOrder navSalesOrder)
        {
            _navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navSalesOrderCommands.Patch(navSalesOrder);
        }
        /// <summary>
        /// Create NAV Order From M4PL Jobs
        /// </summary>
        /// <param name="jobIdList">List of M4PL Job Id</param>
        /// <returns></returns>
        [CustomAuthorize]
		[HttpPost]
		[Route("GenerateSalesOrder")]
		public NavSalesOrderCreationResponse GenerateSalesOrder(List<long> jobIdList)
		{
            _navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navSalesOrderCommands.CreateOrderInNAVFromM4PLJob(jobIdList);
		}
        /// <summary>
        /// Update Sales Order in NAV From M4PL Job
        /// </summary>
        /// <param name="jobIdList">List of M4PL Job ID</param>
        /// <returns></returns>
		[CustomAuthorize]
		[HttpPut]
		[Route("UpdateSalesOrder")]
		public NavSalesOrderCreationResponse UpdateSalesOrder(List<long> jobIdList)
		{
            _navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _navSalesOrderCommands.CreateOrderInNAVFromM4PLJob(jobIdList);
		}
        /// <summary>
        /// Create Single NAV Order From M4PL Job
        /// </summary>
        /// <param name="jobId">M4PL Job Id</param>
        /// <returns></returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("GenerateOrdersInNav")]
		public M4PLOrderCreationResponse GenerateOrdersInNav(long jobId)
		{
			_navSalesOrderCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _navSalesOrderCommands.GenerateOrderInNav(jobId);
		}
	}
}