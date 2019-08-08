/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Nikhil
//Date Programmed:                              24/07/2019
//Program Name:                                 PrgCostLocations
//Purpose:                                      End point to interact with Program Cost Location module
//====================================================================================================================================================*/
using M4PL.API.Filters;
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
        public  IQueryable<TreeModel> CostLocationTree(long? parentId, bool isChild, bool isAssignedCostLocation, long programId )
        {
            return _prgCostLocationCommands.CostLocationTree(ActiveUser.OrganizationId, isAssignedCostLocation, programId, parentId, isChild).AsQueryable();
        }


		[CustomAuthorize]
		[HttpPost]
		[Route("MapVendorCostLocations")]
		public bool MapVendorCostLocations(ProgramVendorMap programVendorMap)
		{
			return _prgCostLocationCommands.MapVendorCostLocations(ActiveUser, programVendorMap);
		}
	}
}