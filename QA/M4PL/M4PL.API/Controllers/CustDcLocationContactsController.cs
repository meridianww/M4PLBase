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
//Program Name:                                 CustDcLocationContact
//Purpose:                                      End point to interact with Customer Dc Location Contact module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/CustDcLocationContacts")]
	public class CustDcLocationContactsController : BaseApiController<CustDcLocationContact>
	{
		private readonly ICustDcLocationContactCommands _custDcLocationContactCommands;

		/// <summary>
		/// Function to get Customer's DC Location Contact details
		/// </summary>
		/// <param name="custDcLocationContactCommands"></param>
		public CustDcLocationContactsController(ICustDcLocationContactCommands custDcLocationContactCommands)
			: base(custDcLocationContactCommands)
		{
			_custDcLocationContactCommands = custDcLocationContactCommands;
		}

		[CustomAuthorize]
		[HttpGet]
		[Route("GetCustDcLocationContact")]
		public CustDcLocationContact GetCustDcLocationContact(long id, long? parentId)
		{
			return _custDcLocationContactCommands.GetCustDcLocationContact(ActiveUser, id, parentId);
		}
	}
}