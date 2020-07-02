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
//Program Name:                                 ScrRequirementListsController
//Purpose:                                      End point to interact with ScrRequirementList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/ScrRequirementLists")]
	public class ScrRequirementListsController : BaseApiController<ScrRequirementList>
	{
		private readonly IScrRequirementListCommands _scrRequirementListCommands;

		/// <summary>
		/// Function to get the ScrRequirementList details
		/// </summary>
		/// <param name="scrRequirementListCommands"></param>
		public ScrRequirementListsController(IScrRequirementListCommands scrRequirementListCommands)
			: base(scrRequirementListCommands)
		{
			_scrRequirementListCommands = scrRequirementListCommands;
		}
	}
}