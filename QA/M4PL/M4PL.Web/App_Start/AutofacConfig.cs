#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using Autofac;
using Autofac.Integration.Mvc;
using M4PL.Web.IoC;
using System.Web.Mvc;

namespace M4PL.Web
{
	public static class AutofacConfig
	{
		public static void RegisterDependencies()
		{
			var mvcContainer = BuildMvcContainer();
			DependencyResolver.SetResolver(new AutofacDependencyResolver(mvcContainer));
		}

		private static IContainer BuildMvcContainer()
		{
			var containerBuilder = new ContainerBuilder();
			RegisterCoreModules(containerBuilder);

			// All MVC controllers
			containerBuilder.RegisterControllers(typeof(MvcApplication).Assembly);

			// Register for filters
			containerBuilder.RegisterFilterProvider();

			return containerBuilder.Build();
		}

		private static void RegisterCoreModules(ContainerBuilder containerBuilder)
		{
			////provides HttpContext, Request, Response, etc
			containerBuilder.RegisterModule(new AutofacWebTypesModule());

			containerBuilder.RegisterModule(new AdminModule());
			containerBuilder.RegisterModule(new ContactModule());
			containerBuilder.RegisterModule(new CustomerModule());
			containerBuilder.RegisterModule(new JobModule());
			containerBuilder.RegisterModule(new OrganizationModule());
			containerBuilder.RegisterModule(new ProgramModule());
			containerBuilder.RegisterModule(new VendorModule());
			containerBuilder.RegisterModule(new ScannerModule());
			containerBuilder.RegisterModule(new AttachmentModule());
			containerBuilder.RegisterModule(new FinanceModule());
		}
	}
}