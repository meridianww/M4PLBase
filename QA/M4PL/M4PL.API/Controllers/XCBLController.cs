#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.XCBL;
using M4PL.Entities.Support;
using M4PL.Entities.XCBL;
using M4PL.Entities.XCBL.Electrolux;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.Electrolux.OrderResponse;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Description;


namespace M4PL.API.Controllers
{
    
    /// <summary>
    /// XCBL Summary Header
    /// </summary>
    
    [CustomAuthorize]
    [RoutePrefix("api/XCBL")]
    public class XCBLController : ApiController
	{
		private readonly IXCBLCommands _xcblCommands;

		/// <summary>
		/// Function to get xcblCommands details
		/// </summary>
		/// <param name="xcblCommands"></param>
		public XCBLController(IXCBLCommands xcblCommands)
		{
			_xcblCommands = xcblCommands;
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
        public virtual IQueryable<XCBLToM4PLRequest> PagedData(PagedDataInfo pagedDataInfo)
        {
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the xCBLToM4PLRequest.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual XCBLToM4PLRequest Get(long id)
        {
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new xCBLToM4PLRequest object passed as parameter.
        /// </summary>
        /// <param name="xCBLToM4PLRequest">Refers to xCBLToM4PLRequest object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual XCBLToM4PLRequest Post(XCBLToM4PLRequest xCBLToM4PLRequest)
        {
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.Post(xCBLToM4PLRequest);
        }

        /// <summary>
        /// Put method is used to update record values completely based on xCBLToM4PLRequest object passed.
        /// </summary>
        /// <param name="xCBLToM4PLRequest">Refers to xCBLToM4PLRequest object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual XCBLToM4PLRequest Put(XCBLToM4PLRequest xCBLToM4PLRequest)
        {
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.Put(xCBLToM4PLRequest);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.Delete(id);
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
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on xCBLToM4PLRequest object passed.
        /// </summary>
        /// <param name="xCBLToM4PLRequest">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual XCBLToM4PLRequest Patch(XCBLToM4PLRequest xCBLToM4PLRequest)
        {
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.Patch(xCBLToM4PLRequest);
        }

        /// <summary>
        ///The requested information such as Header, Address, UDF, CustomAttribute, Line Detail will be inserted into respective xcbl tables and in future it will be used for mannually accepting changes.
        /// For Shipping Schedule Request.It will compare the fields with existing job.If there the a change in fields, action Codes Mapped in the Decision Maker will be Added to the Job.
        /// If the Added Gateway/Action is Marked as complete based on the settings from Program the new values will be Updated in Job else On completion of Gateway/Action new values will be updated.
        /// </summary>
        /// <param name="xCBLToM4PLRequest">The request may be type of either Shipping schedule or Requisition</param>
        /// <returns>Inserted Xcbl Summary Header Id</returns>
        [CustomAuthorize]
		[HttpPost]
		[Route("XCBLSummaryHeader"), ResponseType(typeof(long))]
		public long InsertXCBLSummaryHeader(XCBLToM4PLRequest xCBLToM4PLRequest)
		{
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.PostXCBLSummaryHeader(xCBLToM4PLRequest);
		}

		/// <summary>
		///Request will be validated
		///The requested information such as Header, Address, UDF, CustomAttribute, Line Detail will be inserted into respective xcbl tables
		///and in future it will be used for mannually accepting changes.
		///If request is of type Order and if type of the action is ADD, new job will be created  along with Cargo and its price and cost will be inserted.If action is DELETE then Job will be cancelled.
		///If the request is of type ASN and the ACTION is of type ADD then requested Job will be updated with the details also price and cost details also updated. If the Action is of type DELTE then nothing will happen.
		///For the ASN request if the Gateway status in In Production In Transit gateway will be added automatically.
		/// </summary>
		/// <param name="electroluxOrderDetails">Electrolux Order details request may be either type of Order or ASN. Order is to create new order and ASN is to update existing Order.</param>
		/// <returns>Order response with Job Id and Status Code and message</returns>
		[CustomAuthorize]
		[HttpPost]
		[Route("Electrolux/OrderRequest"), ResponseType(typeof(OrderResponse))]
		public OrderResponse ProcessElectroluxOrderRequest(ElectroluxOrderDetails electroluxOrderDetails)
		{
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.ProcessElectroluxOrderRequest(electroluxOrderDetails);
		}

		/// <summary>
		/// The changes made in M4PL will be sent to Electrolux for the supplied job Id.
		/// The url for the Electrolux endpoint is configurable. Then delivery update will be inserted into EDI table.
		/// </summary>
		/// <param name="deliveryUpdate">Model which contains delivery update to an order.</param>
		/// <returns>Response returned from Electrolux</returns>
		[CustomAuthorize]
		[HttpPost]
		[Route("Electrolux/OrderDeliveryUpdate"), ResponseType(typeof(DeliveryUpdateResponse))]
		public DeliveryUpdateResponse ProcessElectroluxOrderDeliveryUpdate(DeliveryUpdate deliveryUpdate, long jobId)
		{
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.ProcessElectroluxOrderDeliveryUpdate(deliveryUpdate, jobId);
		}

		/// <summary>
		/// Get the list of Un processed delivery update logs
		/// </summary>
		/// <returns>List of unprocessed delivery update logs</returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("Electrolux/DeliveryUpdateProcessingData"), ResponseType(typeof(List<DeliveryUpdateProcessingData>))]
		public List<DeliveryUpdateProcessingData> GetDeliveryUpdateProcessingData()
		{
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.GetDeliveryUpdateProcessingData();
		}

		/// <summary>
		/// Marks the Delivery Update log entry as processed
		/// </summary>
		/// <param name="deliveryUpdateProcessingData">Delivery update log entry</param>
		/// <returns>Returns true if the update is success else false</returns>
		[CustomAuthorize]
		[HttpPost]
		[Route("Electrolux/UpdateProcessingData"), ResponseType(typeof(bool))]
		public bool UpdateDeliveryUpdateProcessingLog(DeliveryUpdateProcessingData deliveryUpdateProcessingData)
		{
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.UpdateDeliveryUpdateProcessingLog(deliveryUpdateProcessingData);
		}

		/// <summary>
		/// Returns the data in the format of delivery update model with the necessary fields to send the order update to electrolux by the jobId
		/// </summary>
		/// <param name="jobId">job id</param>
		/// <returns>Delivery update model</returns>
		[CustomAuthorize]
		[HttpGet]
		[Route("Electrolux/GetDeliveryUpdateModel"), ResponseType(typeof(DeliveryUpdate))]
		public DeliveryUpdate GetDeliveryUpdateModel(long jobId)
		{
            _xcblCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _xcblCommands.GetDeliveryUpdateModel(jobId);
		}
	}
}