using Autofac;
using M4PL.Business.XCBL;


namespace M4PL.API.IoC
{
	public class XcblModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<XCBLCommands>().As<IXCBLCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}