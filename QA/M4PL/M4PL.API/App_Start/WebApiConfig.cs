﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.API.Controllers;
using M4PL.API.Models;
using Orbit.WebApi.Core.Dependency;
using Orbit.WebApi.Security;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Routing;

namespace M4PL.API
{
	public static class WebApiConfig
	{
		public static void Register(HttpConfiguration config)
		{
			config.EnableCors();
			
			// Web API routes
			config.MapHttpAttributeRoutes();

			config.Routes.MapHttpRoute("DefaultApiWithId", "api/{controller}/{id}", new { id = RouteParameter.Optional }, new { id = @"\d+" });
			config.Routes.MapHttpRoute("DefaultApiWithAction", "api/{controller}/{action}");
			config.Routes.MapHttpRoute("DefaultApiGet", "api/{controller}", new { action = "Get" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
			config.Routes.MapHttpRoute("DefaultApiPost", "api/{controller}", new { action = "Post" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });
			config.Routes.MapHttpRoute("DefaultApiGetAction", "api/{controller}/{action}", new { action = "Get" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Get) });
			config.Routes.MapHttpRoute("DefaultApiPostAction", "api/{controller}/{action}", new { action = "Post" }, new { httpMethod = new HttpMethodConstraint(HttpMethod.Post) });

			config.Routes.MapHttpRoute(
				"DefaultApi",
				"api/{controller}/{id}",
				new { id = RouteParameter.Optional }
			);

			config.Filters.Add(new GlobalExceptionFilterAttribute());

			DependencyResolverContainer.RegisterInstance<ISecurityCommand>(new SecurityCommands());
		}
	}
}