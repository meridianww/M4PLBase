/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CustomerDcLocation
//Purpose:                                      End point to interact with Customer DcLocation module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/CustDcLocations")]
    public class CustDcLocationsController : BaseApiController<CustDcLocation>
    {
        private readonly ICustDcLocationCommands _custDcLocationCommands;

        /// <summary>
        /// Function to get Customer's DC Location details
        /// </summary>
        /// <param name="custDcLocationCommands"></param>
        public CustDcLocationsController(ICustDcLocationCommands custDcLocationCommands)
            : base(custDcLocationCommands)
        {
            _custDcLocationCommands = custDcLocationCommands;
        }
    }
}