/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              09/25/2018
//Program Name:                                 VendDcLocationContact
//Purpose:                                      End point to interact with Vendor Dc Location Contact module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Vendor;
using M4PL.Entities.Vendor;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/VendDcLocationContacts")]
    public class VendDcLocationContactsController : BaseApiController<VendDcLocationContact>
    {
        private readonly IVendDcLocationContactCommands _vendDcLocationContactCommands;

        /// <summary>
        /// Function to get Vendor's DC Location Contact details
        /// </summary>
        /// <param name="vendDcLocationContactCommands"></param>
        public VendDcLocationContactsController(IVendDcLocationContactCommands vendDcLocationContactCommands)
            : base(vendDcLocationContactCommands)
        {
            _vendDcLocationContactCommands = vendDcLocationContactCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GetVendDcLocationContact")]
        public VendDcLocationContact GetVendDcLocationContact(long id, long? parentId)
        {
            return _vendDcLocationContactCommands.GetVendDcLocationContact(ActiveUser, id, parentId);
        }
    }
}