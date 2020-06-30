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
//Programmer:                                   Janardana
//Date Programmed:                              17/12/2017
//Program Name:                                 SystemAccounts
//Purpose:                                      End point to interact with SystemAccount module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/SystemAccounts")]
    public class SystemAccountsController : BaseApiController<SystemAccount>
    {
        private readonly ISystemAccountCommands _systemAccountCommands;

        /// <summary>
        /// Function to get Administraton's SystemAccount details
        /// </summary>
        /// <param name="systemAccountCommands"></param>
        public SystemAccountsController(ISystemAccountCommands systemAccountCommands)
            : base(systemAccountCommands)
        {
            _systemAccountCommands = systemAccountCommands;
        }
    }
}