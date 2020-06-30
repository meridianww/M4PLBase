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
//Program Name:                                 ProgramVendLocations
//Purpose:                                      End point to interact with Program VendLocation module
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
    [RoutePrefix("api/PrgVendLocations")]
    public class PrgVendLocationsController : BaseApiController<PrgVendLocation>
    {
        private readonly IPrgVendLocationCommands _prgVendLocationCommands;

        /// <summary>
        /// Function to get Program's VendLocation details
        /// </summary>
        /// <param name="prgVendLocationCommands"></param>
        public PrgVendLocationsController(IPrgVendLocationCommands prgVendLocationCommands)
            : base(prgVendLocationCommands)
        {
            _prgVendLocationCommands = prgVendLocationCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("ProgramVendorTree")]
        public virtual IQueryable<TreeModel> ProgramVendorTree(bool isAssignedprgVendor, long programId, long? parentId, bool isChild)
        {
            return _prgVendLocationCommands.ProgramVendorTree(ActiveUser, ActiveUser.OrganizationId, isAssignedprgVendor, programId, parentId, isChild).AsQueryable();
        }

        [CustomAuthorize]
        [HttpPost]
        [Route("MapVendorLocations")]
        public bool MapVendorLocations(ProgramVendorMap programVendorMap)
        {
            return _prgVendLocationCommands.MapVendorLocations(ActiveUser, programVendorMap);
        }
    }
}