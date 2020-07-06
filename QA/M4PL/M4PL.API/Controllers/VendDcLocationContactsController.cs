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