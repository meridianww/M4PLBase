﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Validations
//Purpose:                                      End point to interact with Validation module
//====================================================================================================================================================*/

using M4PL.Business.Administration;
using M4PL.Entities.Administration;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/Validations")]
    public class ValidationsController : BaseApiController<Validation>
    {
        private readonly IValidationCommands _validationCommands;

        /// <summary>
        /// Function to get Administraton's Validation details
        /// </summary>
        /// <param name="validationCommands"></param>
        public ValidationsController(IValidationCommands validationCommands)
            : base(validationCommands)
        {
            _validationCommands = validationCommands;
        }
    }
}