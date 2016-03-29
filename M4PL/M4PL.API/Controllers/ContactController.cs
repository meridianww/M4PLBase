using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using M4PL_API_CommonUtils.Model;
using M4PL_BAL.ServerCommand;

namespace M4PL_API.Controllers
{
	public class ContactController : ApiController
	{
		[HttpPost]
		public bool SaveContact(Contact contact)
		{
			ContactServerCommand contactServerCommand = new ContactServerCommand();
			return contactServerCommand.InsertContact(contact);
		}
	}
}