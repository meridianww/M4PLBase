using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using M4PL.Business;
using M4PL.Business.XCBL;
using M4PL.API.Filters;
using System.Web.Http;
using M4PL.Entities.XCBL;

namespace M4PL.API.Controllers
{

    /// <summary>
    /// XCBL Summary Header
    /// </summary>
    [RoutePrefix("api/XCBL")]
    public class XCBLController : ApiController
    {

        private readonly IXCBLCommands _xcblCommands = new XCBLCommands();

        /// <summary>
        /// Function to get Job's advance Report details
        /// </summary>
        /// <param name="xcblCommands"></param>
        public XCBLController(IXCBLCommands xcblCommands)
        {
            _xcblCommands = xcblCommands;
        }

        public XCBLController()
        {
            _xcblCommands = _xcblCommands;
        }

        /// <summary>
        /// Insert XCBL Summary Header
        /// </summary>
        /// <param name="xCBLToM4PLRequisitionRequest"></param>
        /// <returns></returns>
        [CustomAuthorize]
        [HttpPost]
        [Route("XCBLSummaryHeader")]
        public long InsertXCBLSummaryHeader(XCBLToM4PLRequisitionRequest xCBLToM4PLRequisitionRequest)
        {
            return _xcblCommands.PostXCBLSummaryHeader(xCBLToM4PLRequisitionRequest);
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("XCBLGet")]
        public XCBLToM4PLRequisitionRequest XCBLGet()
        {
            var x = new XCBLToM4PLRequisitionRequest() { AgencyCoded = "Test" };
            return x;
        }
    }
}