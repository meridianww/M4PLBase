/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorDocReferences
//Purpose:                                      End point to interact with VendorDocReferences module
//====================================================================================================================================================*/

using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/VendDocReferences")]
    public class VendDocReferencesController : BaseApiController<VendDocReference>
    {
        private readonly IVendDocReferenceCommands _vendDocReferenceCommands;

        /// <summary>
        /// Fucntion to get Vendor's doc reference details
        /// </summary>
        /// <param name="vendDocReferenceCommands"></param>
        public VendDocReferencesController(IVendDocReferenceCommands vendDocReferenceCommands)
            : base(vendDocReferenceCommands)
        {
            _vendDocReferenceCommands = vendDocReferenceCommands;
        }
    }
}