/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              09/25/2018
//Program Name:                                 CustDcLocationContact
//Purpose:                                      End point to interact with Customer Dc Location Contact module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/CustDcLocationContacts")]
    public class CustDcLocationContactsController : BaseApiController<CustDcLocationContact>
    {
        private readonly ICustDcLocationContactCommands _custDcLocationContactCommands;

        /// <summary>
        /// Function to get Customer's DC Location Contact details
        /// </summary>
        /// <param name="custDcLocationContactCommands"></param>
        public CustDcLocationContactsController(ICustDcLocationContactCommands custDcLocationContactCommands)
            : base(custDcLocationContactCommands)
        {
            _custDcLocationContactCommands = custDcLocationContactCommands;
        }

        [CustomAuthorize]
        [HttpGet]
        [Route("GetCustDcLocationContact")]
        public CustDcLocationContact GetCustDcLocationContact(long id, long? parentId)
        {
            return _custDcLocationContactCommands.GetCustDcLocationContact(ActiveUser, id, parentId);
        }
    }
}