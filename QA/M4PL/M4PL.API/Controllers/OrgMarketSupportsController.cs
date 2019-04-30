/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizationMarketSupport
//Purpose:                                      End point to interact with Organization Market Support module
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/OrgMarketSupports")]
    public class OrgMarketSupportsController : BaseApiController<OrgMarketSupport>
    {
        private readonly IOrgMarketSupportCommands _orgMarketSupportCommands;

        /// <summary>
        /// Function to get Organization market support details
        /// </summary>
        /// <param name="orgMarketSupportCommands"></param>
        public OrgMarketSupportsController(IOrgMarketSupportCommands orgMarketSupportCommands)
            : base(orgMarketSupportCommands)
        {
            _orgMarketSupportCommands = orgMarketSupportCommands;
        }
    }
}