using Autofac;
using M4PL.Business.Signature;

namespace M4PL.API.IoC
{
    /// <summary>
    /// signature
    /// </summary>
    public class SignatureModule : Module
    {
        /// <summary>
        /// signature
        /// </summary>
        /// <param name="builder"></param>
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<JobSignatureCommands>().As<IJobSignatureCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}