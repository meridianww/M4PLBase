/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorContacts
//Purpose:                                      End point to interact with Vendor Contacts module
//====================================================================================================================================================*/

using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/VendContacts")]
    public class VendContactsController : BaseApiController<VendContact>
    {
        private readonly IVendContactCommands _vendContactCommands;

        /// <summary>
        /// Fucntion to get Vendor's Contacts details
        /// </summary>
        /// <param name="vendContactCommands"></param>
        public VendContactsController(IVendContactCommands vendContactCommands)
            : base(vendContactCommands)
        {
            _vendContactCommands = vendContactCommands;
        }
    }
}