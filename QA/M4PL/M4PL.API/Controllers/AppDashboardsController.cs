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
//Program Name:                                 AppDashboards
//Purpose:                                      End point to interact with App Dashboard
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Common;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [CustomAuthorize]
    [RoutePrefix("api/AppDashboards")]
	public class AppDashboardsController : ApiController
	{
		private readonly IAppDashboardCommands _dashboardCommands;

		/// <summary>
		/// Function to get Administration's menu driver details
		/// </summary>
		/// <param name="dashboardCommands"></param>
		public AppDashboardsController(IAppDashboardCommands dashboardCommands)
			
		{
			_dashboardCommands = dashboardCommands;
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
        public virtual IQueryable<AppDashboard> PagedData(PagedDataInfo pagedDataInfo)
        {
            _dashboardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _dashboardCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the appDashboard.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual AppDashboard Get(long id)
        {
            _dashboardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _dashboardCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new appDashboard object passed as parameter.
        /// </summary>
        /// <param name="appDashboard">Refers to appDashboard object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual AppDashboard Post(AppDashboard appDashboard)
        {
            _dashboardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _dashboardCommands.Post(appDashboard);
        }

        /// <summary>
        /// Put method is used to update record values completely based on appDashboard object passed.
        /// </summary>
        /// <param name="appDashboard">Refers to appDashboard object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual AppDashboard Put(AppDashboard appDashboard)
        {
            _dashboardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _dashboardCommands.Put(appDashboard);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _dashboardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _dashboardCommands.Delete(id);
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
            _dashboardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _dashboardCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on appDashboard object passed.
        /// </summary>
        /// <param name="appDashboard">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual AppDashboard Patch(AppDashboard appDashboard)
        {
            _dashboardCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _dashboardCommands.Patch(appDashboard);
        }
    }
}