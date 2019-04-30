/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScnOrderRequirementsController
//Purpose:                                      End point to interact with ScnOrderRequirement
//====================================================================================================================================================*/

using M4PL.Business.Scanner;
using M4PL.Entities.Scanner;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/ScnOrderRequirements")]
    public class ScnOrderRequirementsController : BaseApiController<ScnOrderRequirement>
    {
        private readonly IScnOrderRequirementCommands _ScnOrderRequirementCommands;

        /// <summary>
        /// Function to get the ScnOrderRequirement details
        /// </summary>
        /// <param name="scnOrderRequirementCommands"></param>
        public ScnOrderRequirementsController(IScnOrderRequirementCommands scnOrderRequirementCommands)
            : base(scnOrderRequirementCommands)
        {
            _ScnOrderRequirementCommands = scnOrderRequirementCommands;
        }
    }
}