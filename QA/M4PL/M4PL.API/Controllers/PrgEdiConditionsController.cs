#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

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