﻿
/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              28/07/2018
//Program Name:                                 ScnOrder
//Purpose:                                      Contains Actions to render view on ScnOrder page
//====================================================================================================================================================*/

using M4PL.APIClient.Common;
using M4PL.APIClient.Scanner;
using M4PL.APIClient.ViewModels.Scanner;

namespace M4PL.Web.Areas.Scanner.Controllers
{
    public class ScnOrderController : BaseController<ScnOrderView>
    {
        public ScnOrderController(IScnOrderCommands scnOrderCommands, ICommonCommands commonCommands) : base(scnOrderCommands)
        {
            _commonCommands = commonCommands;
        }
    }
}