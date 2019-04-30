/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScrRequirementListsController
//Purpose:                                      End point to interact with ScrRequirementList
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScrRequirementLists")]
    public class ScrRequirementListsController : BaseApiController<ScrRequirementList>
    {
        private readonly IScrRequirementListCommands _scrRequirementListCommands;

        /// <summary>
        /// Function to get the ScrRequirementList details
        /// </summary>
        /// <param name="scrRequirementListCommands"></param>
        public ScrRequirementListsController(IScrRequirementListCommands scrRequirementListCommands)
            : base(scrRequirementListCommands)
        {
            _scrRequirementListCommands = scrRequirementListCommands;
        }
    }
}