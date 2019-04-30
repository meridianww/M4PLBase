/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramMvocs
//Purpose:                                      End point to interact with Program Mvoc module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgMvocs")]
    public class PrgMvocsController : BaseApiController<PrgMvoc>
    {
        private readonly IPrgMvocCommands _prgMvocCommands;

        /// <summary>
        /// Function to get Program's mvoc details
        /// </summary>
        /// <param name="prgMvocCommands"></param>
        public PrgMvocsController(IPrgMvocCommands prgMvocCommands)
            : base(prgMvocCommands)
        {
            _prgMvocCommands = prgMvocCommands;
        }
    }
}