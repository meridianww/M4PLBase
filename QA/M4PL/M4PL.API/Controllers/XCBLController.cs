using M4PL.API.Filters;
using M4PL.Business.XCBL;
using M4PL.Entities.XCBL;
using M4PL.Entities.XCBL.Electrolux;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest;
using M4PL.Entities.XCBL.Electrolux.DeliveryUpdateResponse;
using M4PL.Entities.XCBL.Electrolux.OrderRequest;
using M4PL.Entities.XCBL.Electrolux.OrderResponse;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Description;

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
            BaseCommands.ActiveUser = ActiveUser;
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
            _xcblCommands.ActiveUser = ActiveUser;
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