using Autofac;
using M4PL.Business.XCBL;


namespace M4PL.API.IoC
{
    /// <summary>
    /// XcblModule
    /// </summary>
	public class XcblModule : Module
	{
        /// <summary>
        /// Load
        /// </summary>
        /// <param name="builder"></param>
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<XCBLCommands>().As<IXCBLCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}