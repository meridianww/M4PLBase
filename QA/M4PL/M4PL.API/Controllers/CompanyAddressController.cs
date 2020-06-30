#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

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
