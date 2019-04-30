/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrCatalogListsController
//Purpose:                                      End point to interact with ScrCatalogList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScrCatalogLists")]
    public class ScrCatalogListsController : BaseApiController<ScrCatalogList>
    {
        private readonly IScrCatalogListCommands _scrCatalogListCommands;

        /// <summary>
        /// Function to get the ScrCatalogList details
        /// </summary>
        /// <param name="scrCatalogListCommands"></param>
        public ScrCatalogListsController(IScrCatalogListCommands scrCatalogListCommands)
            : base(scrCatalogListCommands)
        {
            _scrCatalogListCommands = scrCatalogListCommands;
        }
    }
}