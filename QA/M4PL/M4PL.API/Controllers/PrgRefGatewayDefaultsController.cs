/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramRefGatewayDefaults
//Purpose:                                      End point to interact with Program RefGatewayDefaults module
//====================================================================================================================================================*/

using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgRefGatewayDefaults")]
    public class PrgRefGatewayDefaultsController : BaseApiController<PrgRefGatewayDefault>
    {
        private readonly IPrgRefGatewayDefaultCommands _prgRefGatewayDefaultCommands;


        /// <summary>
        /// Function to get Program's RefGatewayDefault details
        /// </summary>
        /// <param name="prgRefGatewayDefaultCommands"></param>
        public PrgRefGatewayDefaultsController(IPrgRefGatewayDefaultCommands prgRefGatewayDefaultCommands)
            : base(prgRefGatewayDefaultCommands)
        {
            _prgRefGatewayDefaultCommands = prgRefGatewayDefaultCommands;
        }

        /// <summary>
        /// New put with user sys settings
        /// </summary>
        /// <param name="prgRefGatewayDefault"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("SettingPost")]
        public PrgRefGatewayDefault SettingPost(PrgRefGatewayDefault prgRefGatewayDefault)
        {
            _prgRefGatewayDefaultCommands.ActiveUser = ActiveUser;
            return _prgRefGatewayDefaultCommands.PostWithSettings(UpdateActiveUserSettings(), prgRefGatewayDefault);
        }

        /// <summary>
        /// New put with user sys settings
        /// </summary>
        /// <param name="prgRefGatewayDefault"></param>
        /// <returns></returns>
        [HttpPut]
        [Route("SettingPut")]
        public PrgRefGatewayDefault SettingPut(PrgRefGatewayDefault prgRefGatewayDefault)
        {
            _prgRefGatewayDefaultCommands.ActiveUser = ActiveUser;
            return _prgRefGatewayDefaultCommands.PutWithSettings(UpdateActiveUserSettings(), prgRefGatewayDefault);
        }
    }
}