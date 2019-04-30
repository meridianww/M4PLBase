/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorBusinessTerms
//Purpose:                                      End point to interact with Vendor Business Terms module
//====================================================================================================================================================*/

using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/VendBusinessTerms")]
    public class VendBusinessTermsController : BaseApiController<VendBusinessTerm>
    {
        private readonly IVendBusinessTermCommands _vendBusinessTermCommands;

        /// <summary>
        /// Function to get Vendor's Business terms details
        /// </summary>
        /// <param name="vendBusinessTermCommands"></param>
        public VendBusinessTermsController(IVendBusinessTermCommands vendBusinessTermCommands)
            : base(vendBusinessTermCommands)
        {
            _vendBusinessTermCommands = vendBusinessTermCommands;
        }
    }
}