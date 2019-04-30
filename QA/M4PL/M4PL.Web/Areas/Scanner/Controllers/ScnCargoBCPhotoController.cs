using M4PL.APIClient.Common;
/*Copyright (2016) Meridian Worldwide Transportation Group

//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              26/07/2018
//Program Name:                                 ScnCargoBCPhoto
//Purpose:                                      Contains Actions to render view on ScnCargoBCPhoto page
//====================================================================================================================================================*/

using M4PL.APIClient.Scanner;
using M4PL.APIClient.ViewModels.Scanner;

namespace M4PL.Web.Areas.Scanner.Controllers
{
    public class ScnCargoBCPhotoController : BaseController<ScnCargoBCPhotoView>
    {
        public ScnCargoBCPhotoController(IScnCargoBCPhotoCommands scnCargoBCPhotoCommands, ICommonCommands commonCommands) : base(scnCargoBCPhotoCommands)
        {
            _commonCommands = commonCommands;
        }
    }
}