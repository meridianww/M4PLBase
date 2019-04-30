/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CusotmerContacts
//Purpose:                                      End point to interact with Cusotmer Contacts module
//====================================================================================================================================================*/

using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/CustContacts")]
    public class CustContactsController : BaseApiController<CustContact>
    {
        private readonly ICustContactCommands _custContactCommands;

        /// <summary>
        /// Function to get Customer's Contacts details
        /// </summary>
        /// <param name="custContactCommands"></param>
        public CustContactsController(ICustContactCommands custContactCommands)
            : base(custContactCommands)
        {
            _custContactCommands = custContactCommands;
        }
    }
}