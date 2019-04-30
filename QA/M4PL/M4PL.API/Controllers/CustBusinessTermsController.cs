/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CustomerBusinessTerms
//Purpose:                                      End point to interact with CustomerBusinessTerms module
//====================================================================================================================================================*/

using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/CustBusinessTerms")]
    public class CustBusinessTermsController : BaseApiController<CustBusinessTerm>
    {
        private readonly ICustBusinessTermCommands _custBusinessTermCommands;

        /// <summary>
        /// Function to get Customer's business Terms details
        /// </summary>
        /// <param name="custBusinessTermCommands"></param>
        public CustBusinessTermsController(ICustBusinessTermCommands custBusinessTermCommands)
            : base(custBusinessTermCommands)
        {
            _custBusinessTermCommands = custBusinessTermCommands;
        }
    }
}