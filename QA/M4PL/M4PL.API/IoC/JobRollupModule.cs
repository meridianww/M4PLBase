using Autofac;
using M4PL.Business.JobRollup;

namespace M4PL.API.IoC
{
    /// <summary>
    /// JobRollup Module
    /// </summary>
    public class JobRollupModule : Module
    {
        /// <summary>
        /// Load
        /// </summary>
        /// <param name="builder"></param>
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<JobRollupCommands>().As<IJobRollupCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}