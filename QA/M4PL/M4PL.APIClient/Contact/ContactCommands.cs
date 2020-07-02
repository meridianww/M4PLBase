#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ContactCommands
// Purpose:                                      Client to consume M4PL API called ContactController
//=================================================================================================================

using M4PL.APIClient.ViewModels.Contact;
using M4PL.Entities;


//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              04/04/2017
// Program Name:                                 ContactCommands
// Purpose:                                      Contains Actions to render view on Customer's Business Term page
//====================================================================================================================================================

using Newtonsoft.Json;
using RestSharp;
using System.Linq;

namespace M4PL.APIClient.Contact
{
    public class ContactCommands : BaseCommands<ContactView>, IContactCommands
    {
        /// <summary>
        /// Route to call Contacts
        /// </summary>
        public override string RouteSuffix
        {
            get { return "Contacts"; }
        }

        public Entities.Contact.Contact PutContactCard(Entities.Contact.Contact contact)
        {
            return JsonConvert.DeserializeObject<ApiResult<Entities.Contact.Contact>>(RestClient.Execute(
                 HttpRestClient.RestAuthRequest(Method.PUT, string.Format("{0}/{1}", RouteSuffix, "ContactCard"), ActiveUser).AddObject(contact)).Content).Results?.FirstOrDefault();
        }

        public Entities.Contact.Contact PostContactCard(Entities.Contact.Contact contact)
        {
            return JsonConvert.DeserializeObject<ApiResult<Entities.Contact.Contact>>(RestClient.Execute(
                 HttpRestClient.RestAuthRequest(Method.PUT, string.Format("{0}/{1}", RouteSuffix, "AddContactCard"), ActiveUser).AddObject(contact)).Content).Results?.FirstOrDefault();
        }

        public bool CheckContactLoggedIn(long contactId)
        {
            var result = JsonConvert.DeserializeObject<ApiResult<bool>>(RestClient.Execute(
                 HttpRestClient.RestAuthRequest(Method.GET, string.Format("{0}/{1}", RouteSuffix, "CheckContactLoggedIn"), ActiveUser).AddParameter("contactId", contactId)).Content).Results?.FirstOrDefault();

            return result.HasValue ? (bool)result : false;
        }
    }
}