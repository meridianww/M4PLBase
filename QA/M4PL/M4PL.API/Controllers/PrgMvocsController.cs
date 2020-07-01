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