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
//Program Name:                                 OrganizationPocContacts
//Purpose:                                      End point to interact with Organization Poc Contacts module
//====================================================================================================================================================*/

using M4PL.Business.Organization;
using M4PL.Entities.Organization;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/OrgPocContacts")]
    public class OrgPocContactsController : BaseApiController<OrgPocContact>
    {
        private readonly IOrgPocContactCommands _orgPocContactCommands;

        /// <summary>
        /// Function to get Organization's poc contact details
        /// </summary>
        /// <param name="orgPocContactCommands"></param>
        public OrgPocContactsController(IOrgPocContactCommands orgPocContactCommands)
            : base(orgPocContactCommands)
        {
            _orgPocContactCommands = orgPocContactCommands;
        }
    }
}