/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramRefAttributeDefaults
//Purpose:                                      End point to interact with Program Ref Attribute Default module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgRefAttributeDefaults")]
    public class PrgRefAttributeDefaultsController : BaseApiController<PrgRefAttributeDefault>
    {
        private readonly IPrgRefAttributeDefaultCommands _prgRefAttributeDefaultCommands;

        /// <summary>
        /// Fucntion to get Program's RefAttributeDefault details
        /// </summary>
        /// <param name="prgRefAttributeDefaultCommands"></param>
        public PrgRefAttributeDefaultsController(IPrgRefAttributeDefaultCommands prgRefAttributeDefaultCommands)
            : base(prgRefAttributeDefaultCommands)
        {
            _prgRefAttributeDefaultCommands = prgRefAttributeDefaultCommands;
        }
    }
}