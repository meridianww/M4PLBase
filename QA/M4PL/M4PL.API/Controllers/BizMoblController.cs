#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.API.Filters;
using M4PL.Business.BizMobl;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web.Http;
using System.Web.Http.Description;

namespace M4PL.API.Controllers
{
	[CustomAuthorize]
	[RoutePrefix("api/BizMobl")]
	public class BizMoblController : ApiController
	{
		private readonly IBizMoblCommands _bizMoblCommands;

		public BizMoblController(IBizMoblCommands bizMoblCommands)
		{
			_bizMoblCommands = bizMoblCommands;
		}

		[HttpGet]
		[Route("GenerateCSVByFileName"), ResponseType(typeof(StatusModel))]
		public StatusModel GenerateCSVByFileName(string fileName)
		{
			if (string.IsNullOrEmpty(fileName))
			{
				return new StatusModel() { AdditionalDetail = "File name can not be empty.", Status = "Failure", StatusCode = (int)HttpStatusCode.ExpectationFailed };
			}

			_bizMoblCommands.ActiveUser = Models.ApiContext.ActiveUser;
			return _bizMoblCommands.GenerateCSVByFileName(fileName);
		}
	}
}