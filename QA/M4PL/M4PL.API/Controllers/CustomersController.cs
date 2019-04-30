/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Customer
//Purpose:                                      End point to interact with Customer module
//====================================================================================================================================================*/

using M4PL.Business.Customer;
using M4PL.Entities.Customer;
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
    }
}