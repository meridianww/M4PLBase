/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 SystemReferences
//Purpose:                                      End point to interact with SystemReference module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/SystemReferences")]
    public class SystemReferencesController : BaseApiController<SystemReference>
    {
        private readonly ISystemReferenceCommands _systemReferenceCommands;

        /// <summary>
        /// Function to get Administration's System reference details
        /// </summary>
        /// <param name="systemReferenceCommands"></param>
        public SystemReferencesController(ISystemReferenceCommands systemReferenceCommands)
            : base(systemReferenceCommands)
        {
            _systemReferenceCommands = systemReferenceCommands;
        }

        /// <summary>
        /// Function to get Deleted Records Lookup Ids
        /// </summary>
        /// <param name="allIds"></param>
        [CustomAuthorize]
        [HttpGet]
        [Route("DeletedRecordLookUpIds")]
        public IQueryable<IdRefLangName> GetDeletedRecordLookUpIds(string allIds)
        {
            BaseCommands.ActiveUser = ActiveUser;
            return _systemReferenceCommands.GetDeletedRecordLookUpIds(allIds).AsQueryable();
        }
    }
}