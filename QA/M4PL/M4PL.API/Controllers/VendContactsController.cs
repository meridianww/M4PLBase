#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
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