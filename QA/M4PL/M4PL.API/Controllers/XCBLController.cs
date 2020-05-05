using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using M4PL.Business;
using M4PL.Business.XCBL;
using M4PL.API.Filters;
using System.Web.Http;
using M4PL.Entities.XCBL;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.Electrolux.OrderResponse;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse;
using M4PL.Entities.XCBL.Electrolux;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// XCBL Summary Header
    /// </summary>
    [RoutePrefix("api/XCBL")]
    public class XCBLController : BaseApiController<XCBLToM4PLRequest>
	{

		private readonly IXCBLCommands _xcblCommands;

		/// <summary>
		/// Function to get xcblCommands details
		/// </summary>
		/// <param name="xcblCommands"></param>
		public XCBLController(IXCBLCommands xcblCommands)
            : base(xcblCommands)
        {
			_xcblCommands = xcblCommands;
		}

		/// <summary>
		/// Insert XCBL Summary Header
		/// </summary>
		/// <param name="xCBLToM4PLRequisitionRequest"></param>
		/// <returns></returns>
		[CustomAuthorize]
        [HttpPost]
        [Route("XCBLSummaryHeader")]
        public long InsertXCBLSummaryHeader(XCBLToM4PLRequest xCBLToM4PLRequest)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _xcblCommands.PostXCBLSummaryHeader(xCBLToM4PLRequest);
        }

		/// <summary>
		/// Process Electrolux Order Request
		/// </summary>
		/// <param name="electroluxOrderDetails">electroluxOrderDetails</param>
		/// <returns></returns>
		[CustomAuthorize]
		[HttpPost]
		[Route("Electrolux/OrderRequest")]
		public OrderResponse ProcessElectroluxOrderRequest(ElectroluxOrderDetails electroluxOrderDetails)
		{
			_xcblCommands.ActiveUser = ActiveUser;
			return _xcblCommands.ProcessElectroluxOrderRequest(electroluxOrderDetails);
		}

		/// <summary>
		/// Process Electrolux Order Delivery Update
		/// </summary>
		/// <param name="deliveryUpdate">deliveryUpdate</param>
		/// <returns></returns>
		[CustomAuthorize]
		[HttpPost]
		[Route("Electrolux/OrderDeliveryUpdate")]
		public DeliveryUpdateResponse ProcessElectroluxOrderDeliveryUpdate(DeliveryUpdate deliveryUpdate, long jobId)
		{
			_xcblCommands.ActiveUser = ActiveUser;
			return _xcblCommands.ProcessElectroluxOrderDeliveryUpdate(deliveryUpdate, jobId);
		}

		[CustomAuthorize]
		[HttpGet]
		[Route("Electrolux/DeliveryUpdateProcessingData")]
		public List<DeliveryUpdateProcessingData> GetDeliveryUpdateProcessingData()
		{
			_xcblCommands.ActiveUser = ActiveUser;
			return _xcblCommands.GetDeliveryUpdateProcessingData();
		}

		[CustomAuthorize]
		[HttpPost]
		[Route("Electrolux/UpdateProcessingData")]
		public bool UpdateDeliveryUpdateProcessingLog(DeliveryUpdateProcessingData deliveryUpdateProcessingData)
		{
			_xcblCommands.ActiveUser = ActiveUser;
			return _xcblCommands.UpdateDeliveryUpdateProcessingLog(deliveryUpdateProcessingData);
		}

		[CustomAuthorize]
		[HttpGet]
		[Route("Electrolux/GetDeliveryUpdateModel")]
		public DeliveryUpdate GetDeliveryUpdateModel(long jobId)
		{
			_xcblCommands.ActiveUser = ActiveUser;
			return _xcblCommands.GetDeliveryUpdateModel(jobId);
		}
	}
}