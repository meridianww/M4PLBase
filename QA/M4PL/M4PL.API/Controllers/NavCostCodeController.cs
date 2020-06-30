#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using M4PL.Business.Finance.CostCode;
using M4PL.Entities.Finance.CostCode;
using System.Collections.Generic;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// Controller For Nav Related Operations
    /// </summary>
    [RoutePrefix("api/NavCostCode")]
    public class NavCostCodeController : BaseApiController<NavCostCode>
    {
        private readonly INavCostCodeCommands _navCostCodeCommands;

        /// <summary>
        /// Initializes a new instance of the <see cref="NavCostCodeController"/> class.
        /// </summary>
        public NavCostCodeController(INavCostCodeCommands navCostCodeCommands)
            : base(navCostCodeCommands)
        {
            _navCostCodeCommands = navCostCodeCommands;
        }

        [HttpGet]
        [Route("GetAllCostCode")]
        public virtual IList<NavCostCode> GetAllCostCode()
        {
            _navCostCodeCommands.ActiveUser = ActiveUser;
            return _navCostCodeCommands.GetAllCostCode();
        }
    }
}
