using Autofac;
using M4PL.Business.JobRollup;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace M4PL.API.IoC
{
	public class JobRollupModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<JobRollupCommands>().As<IJobRollupCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}