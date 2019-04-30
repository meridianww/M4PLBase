/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Vendors
//Purpose:                                      End point to interact with Vendor module
//====================================================================================================================================================*/

using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/Vendors")]
    public class VendorsController : BaseApiController<Vendor>
    {
        private readonly IVendorCommands _vendorCommands;

        /// <summary>
        /// Fucntion to get Vendor details
        /// </summary>
        /// <param name="vendorCommands"></param>
        public VendorsController(IVendorCommands vendorCommands)
            : base(vendorCommands)
        {
            _vendorCommands = vendorCommands;
        }
    }
}