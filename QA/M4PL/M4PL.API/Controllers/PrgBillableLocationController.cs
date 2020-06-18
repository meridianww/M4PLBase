/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              24/07/2019
Program Name:                                 PrgBillableLocation
Purpose:                                      End point to interact with PrgBillableLocation module
=============================================================================================================*/
using M4PL.API.Filters;
using M4PL.Business.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgBillableLocation")]
    public class PrgBillableLocationController : BaseApiController<PrgBillableLocation>
    {
        private readonly IPrgBillableLocationCommands _prgBillableLocationCommands;
        public PrgBillableLocationController(IPrgBillableLocationCommands prgBillableLocationCommands)
            : base(prgBillableLocationCommands)
        {
            _prgBillableLocationCommands = prgBillableLocationCommands;
        }

        [HttpGet]
        [Route("BillableLocation")]
        public IQueryable<TreeModel> BillableLocationTree(long? parentId, bool isChild, bool isAssignedBillableLocation, long programId)
        {
            return _prgBillableLocationCommands.BillableLocationTree(ActiveUser.OrganizationId, isAssignedBillableLocation, programId, parentId, isChild).AsQueryable();
        }

        [CustomAuthorize]
        [HttpPost]
        [Route("MapVendorBillableLocations")]
        public bool MapVendorBillableLocations(ProgramVendorMap programVendorMap)
        {
            return _prgBillableLocationCommands.MapVendorBillableLocations(ActiveUser, programVendorMap);
        }
    }
}
