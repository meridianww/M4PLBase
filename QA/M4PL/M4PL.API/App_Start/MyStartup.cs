﻿using Autofac;
using Autofac.Integration.WebApi;
using M4PL.API.Handlers;
using M4PL.API.IoC;
using Orbit.WebApi.Extensions;
using Owin;

namespace M4PL.API.App_Start
{
    public class MyStartup : Startup
    {
        public void Configuration(IAppBuilder app)
        {
            var builder = new ContainerBuilder();

            // STANDARD WEB API SETUP:

            // All Web API controllers
            builder.RegisterApiControllers(typeof(WebApiApplication).Assembly);

            // OPTIONAL - Register the filter provider if you have custom filters that need DI.
            // Also hook the filters up to controllers.
            builder.RegisterWebApiFilterProvider(Config);
            builder.RegisterModule(new AdminModule());
            builder.RegisterModule(new ContactModule());
            builder.RegisterModule(new CustomerModule());
            builder.RegisterModule(new JobModule());
            builder.RegisterModule(new OrganizationModule());
            builder.RegisterModule(new ProgramModule());
            builder.RegisterModule(new VendorModule());
            builder.RegisterModule(new ScannerModule());
            builder.RegisterModule(new AttachmentModule());
			builder.RegisterModule(new SurveyModule());
			// Run other optional steps, like registering filters,
			// per-controller-type services, etc., then set the dependency resolver
			// to be Autofac.
			var container = builder.Build();
            Config.DependencyResolver = new AutofacWebApiDependencyResolver(container);

            // OWIN WEB API SETUP:

            // Register the Autofac middleware FIRST, then the Autofac Web API middleware,
            // and finally the standard Web API middleware.
            app.UseAutofacMiddleware(container);
            app.UseAutofacWebApi(Config);
            Config.MessageHandlers.Add(new MetadataHandler());
            base.Configuration(app);
        }
    }
}