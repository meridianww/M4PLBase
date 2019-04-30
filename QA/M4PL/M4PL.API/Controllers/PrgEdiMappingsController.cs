/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramEdiMappings
//Purpose:                                      End point to interact with Program Edi Mappings module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgEdiMappings")]
    public class PrgEdiMappingsController : BaseApiController<PrgEdiMapping>
    {
        private readonly IPrgEdiMappingCommands _prgEdiMappingCommands;

        /// <summary>
        /// Function to get program's edi mapping details
        /// </summary>
        /// <param name="prgEdiMappingCommands"></param>
        public PrgEdiMappingsController(IPrgEdiMappingCommands prgEdiMappingCommands)
            : base(prgEdiMappingCommands)
        {
            _prgEdiMappingCommands = prgEdiMappingCommands;
        }
    }
}