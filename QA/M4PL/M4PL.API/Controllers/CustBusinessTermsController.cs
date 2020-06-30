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