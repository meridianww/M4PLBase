/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrInfoListsController
//Purpose:                                      End point to interact with ScrInfoList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScrInfoLists")]
    public class ScrInfoListsController : BaseApiController<ScrInfoList>
    {
        private readonly IScrInfoListCommands _ScrInfoListCommands;

        /// <summary>
        /// Function to get the ScrInfoList details
        /// </summary>
        /// <param name="scrInfoListCommands"></param>
        public ScrInfoListsController(IScrInfoListCommands scrInfoListCommands)
            : base(scrInfoListCommands)
        {
            _ScrInfoListCommands = scrInfoListCommands;
        }
    }
}