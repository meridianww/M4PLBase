/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Nikhil
//Date Programmed:                              08/21/2019
//Program Name:                                 PrgEdiConditions
//Purpose:                                      End point to interact with Program Edi Conditions module
//====================================================================================================================================================*/
using M4PL.Business.Program;
using M4PL.Entities.Program;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/PrgEdiConditions")]
    public class PrgEdiConditionsController : BaseApiController<PrgEdiCondition>
    {
        private readonly IPrgEdiConditionCommands _prgEdiConditionsCommands;

        /// <summary>
        /// Function to get Program's edi Conditions details
        /// </summary>
        /// <param name="prgEdiConditionCommands"></param>
        public PrgEdiConditionsController(IPrgEdiConditionCommands prgEdiConditionCommands)
            : base(prgEdiConditionCommands)
        {
            _prgEdiConditionsCommands = prgEdiConditionCommands;
        }

    }
}