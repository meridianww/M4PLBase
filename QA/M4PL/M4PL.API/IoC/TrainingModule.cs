using Autofac;
using M4PL.Business.Training;

namespace M4PL.API.IoC
{
	/// <summary>
	/// Training Module
	/// </summary>
	public class TrainingModule : Module
	{
		/// <summary>
		/// Load
		/// </summary>
		/// <param name="builder"></param>
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<TrainingCommands>().As<ITrainingCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}