#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 Customer
//Purpose:                                      End point to interact with Customer module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using System.Collections.Generic;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/Customers")]
    public class CustomersController : BaseApiController<Customer>
    {
        private readonly ICustomerCommands _customerCommands;

        /// <summary>
        /// Fucntion to get Customers details
        /// </summary>
        /// <param name="customerCommands"></param>
        public CustomersController(ICustomerCommands customerCommands)
            : base(customerCommands)
        {
            _customerCommands = customerCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GetActiveCutomers")]
        public List<Entities.Customer.Customer> GetActiveCutomers()
        {
            return _customerCommands.GetActiveCutomers();
        }
    }
}