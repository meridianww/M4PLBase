using Autofac;
using M4PL.Business.JobRollup;

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