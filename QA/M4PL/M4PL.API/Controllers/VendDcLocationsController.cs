/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorDcLocations
//Purpose:                                      End point to interact with Vendor DcLocations module
//====================================================================================================================================================*/

using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/VendDcLocations")]
    public class VendDcLocationsController : BaseApiController<VendDcLocation>
    {
        private readonly IVendDcLocationCommands _vendDcLocationCommands;

        /// <summary>
        /// Function to get Vendor's DC Location details
        /// </summary>
        /// <param name="vendDcLocationCommands"></param>
        public VendDcLocationsController(IVendDcLocationCommands vendDcLocationCommands)
            : base(vendDcLocationCommands)
        {
            _vendDcLocationCommands = vendDcLocationCommands;
        }
    }
}