using Autofac;
using M4PL.Business.JobServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace M4PL.API.IoC
{
    /// <summary>
    /// Jobservice
    /// </summary>
    public class Jobservice : Module
    {
		/// <summary>
		/// signature
		/// </summary>
		/// <param name="builder"></param>
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<JobServiceCommands>().As<IJobServiceCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}