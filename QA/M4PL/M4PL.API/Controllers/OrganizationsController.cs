/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 Organization
//Purpose:                                      End point to interact with Organizationmodule
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/Organizations")]
    public class OrganizationsController : BaseApiController<Organization>
    {
        private readonly IOrganizationCommands _organizationCommands;

        /// <summary>
        /// Function to get Organization details
        /// </summary>
        /// <param name="organizationCommands"></param>
        public OrganizationsController(IOrganizationCommands organizationCommands)
            : base(organizationCommands)
        {
            _organizationCommands = organizationCommands;
        }
    }
}