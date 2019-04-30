
/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              28/07/2018
//Program Name:                                 ScnOrderOSD
//Purpose:                                      Contains Actions to render view on ScnOrderOSD page
//====================================================================================================================================================*/


using M4PL.APIClient.Common;
using M4PL.APIClient.Scanner;
using M4PL.APIClient.ViewModels.Scanner;

namespace M4PL.Web.Areas.Scanner.Controllers
{
    public class ScnOrderOSDController : BaseController<ScnOrderOSDView>
    {
        public ScnOrderOSDController(IScnOrderOSDCommands scnOrderOSDCommands, ICommonCommands commonCommands) : base(scnOrderOSDCommands)
        {
            _commonCommands = commonCommands;
        }
    }
}