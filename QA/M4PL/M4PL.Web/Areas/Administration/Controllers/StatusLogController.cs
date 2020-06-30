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
//Date Programmed:                              06/08/2018
//Program Name:                                 StatusLog
//Purpose:                                      Contains Actions to render view on Status Log over the Pages in the system
//====================================================================================================================================================*/

using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;
using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.Web.Areas.Administration.Controllers
{
    public class StatusLogController : BaseController<StatusLogView>
    {
        /// <summary>
        /// Interacts with the interfaces to get the column alias details and renders to the page
        /// Gets the page related information on the cache basis
        /// </summary>
        /// <param name="statusLogCommands"></param>
        /// <param name="commonCommands"></param>
        public StatusLogController(IStatusLogCommands statusLogCommands, ICommonCommands commonCommands)
            : base(statusLogCommands)
        {
            _commonCommands = commonCommands;
        }
    }
}