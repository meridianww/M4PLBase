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
//Program Name:                                 ProgramEdiHeader
//Purpose:                                      End point to interact with Program Edi Header module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Program;
using M4PL.Entities;
using M4PL.Entities.Program;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgEdiHeaders")]
    public class PrgEdiHeadersController : BaseApiController<PrgEdiHeader>
    {
        private readonly IPrgEdiHeaderCommands _prgEdiHeaderCommands;

        /// <summary>
        /// Function to get Program's edi header details
        /// </summary>
        /// <param name="prgEdiHeaderCommands"></param>
        public PrgEdiHeadersController(IPrgEdiHeaderCommands prgEdiHeaderCommands)
            : base(prgEdiHeaderCommands)
        {
            _prgEdiHeaderCommands = prgEdiHeaderCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("EdiTree")]
        public virtual IQueryable<TreeModel> EdiTree(long? parentId, bool model)
        {
            return _prgEdiHeaderCommands.EdiTree(ActiveUser.OrganizationId, parentId, model).AsQueryable();
        }


        [HttpGet]
        [Route("getProgramLevel")]
        public virtual int GetProgramLevel(long? programId)
        {
            return _prgEdiHeaderCommands.GetProgramLevel(ActiveUser.OrganizationId, programId);
        }
    }
}