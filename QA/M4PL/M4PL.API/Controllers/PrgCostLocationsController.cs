#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Business.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
	[RoutePrefix("api/PrgCostLocations")]
	public class PrgCostLocationsController : BaseApiController<PrgCostLocation>
	{
		private readonly IPrgCostLocationCommands _prgCostLocationCommands;

		/// <summary>
		/// Function to get Program's Role details
		/// </summary>
		/// <param name="prgCostLocationCommands"></param>
		public PrgCostLocationsController(IPrgCostLocationCommands prgCostLocationCommands)
			: base(prgCostLocationCommands)
		{
			_prgCostLocationCommands = prgCostLocationCommands;
		}

		//[CustomAuthorize]
		[HttpGet]
		[Route("CostLocation")]
		public IQueryable<TreeModel> CostLocationTree(long? parentId, bool isChild, bool isAssignedCostLocation, long programId)
		{
			return _prgCostLocationCommands.CostLocationTree(ActiveUser.OrganizationId, isAssignedCostLocation, programId, parentId, isChild).AsQueryable();
		}

		[HttpPost]
		[Route("MapVendorCostLocations")]
		public bool Post(ProgramVendorMap programVendorMap)
		{
			return _prgCostLocationCommands.MapVendorCostLocations(ActiveUser, programVendorMap);
		}
	}
}