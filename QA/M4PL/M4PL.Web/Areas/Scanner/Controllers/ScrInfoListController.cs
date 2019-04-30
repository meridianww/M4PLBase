/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              28/07/2018
//Program Name:                                 ScrInfoList
//Purpose:                                      Contains Actions to render view on ScrInfoList page
//====================================================================================================================================================*/


using M4PL.APIClient.Common;
using M4PL.APIClient.Scanner;
using M4PL.APIClient.ViewModels.Scanner;

namespace M4PL.Web.Areas.Scanner.Controllers
{
    public class ScrInfoListController : BaseController<ScrInfoListView>
    {
        public ScrInfoListController(IScrInfoListCommands scrInfoListCommands, ICommonCommands commonCommands) : base(scrInfoListCommands)
        {
            _commonCommands = commonCommands;
        }
    }
}