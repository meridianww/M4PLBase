/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/11/2019
//Program Name:                                 Company Address
//Purpose:                                      End point to interact with CompanyAddress module
//====================================================================================================================================================*/
using M4PL.Business.CompanyAddress;
using M4PL.Entities.CompanyAddress;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/CompanyAddress")]
    public class CompanyAddressController : BaseApiController<CompanyAddress>
    {
        private readonly ICompanyAddressCommands _companyAddressCommands;

        /// <summary>
        /// Function to get the Company Address details
        /// </summary>
        /// <param name="companyAddressCommands"></param>
        public CompanyAddressController(ICompanyAddressCommands companyAddressCommands)
                : base(companyAddressCommands)
        {
            _companyAddressCommands = companyAddressCommands;
        }
    }
}
