#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 AdminModule
//Purpose:                                      For implementing IOC in Admin module
//====================================================================================================================================================*/

using Autofac;
using M4PL.Business.Administration;
using M4PL.Business.Common;

namespace M4PL.API.IoC
{
	/// <summary>
	/// Admin Module
	/// </summary>
	public class AdminModule : Module
	{
		/// <summary>
		/// Load
		/// </summary>
		/// <param name="builder"></param>
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<ColumnAliasCommands>().As<IColumnAliasCommands>().InstancePerRequest();
			builder.RegisterType<DeliveryStatusCommands>().As<IDeliveryStatusCommands>().InstancePerRequest();
			builder.RegisterType<MenuAccessLevelCommands>().As<IMenuAccessLevelCommands>().InstancePerRequest();
			builder.RegisterType<MenuDriverCommands>().As<IMenuDriverCommands>().InstancePerRequest();
			builder.RegisterType<MenuOptionLevelCommands>().As<IMenuOptionLevelCommands>().InstancePerRequest();
			builder.RegisterType<MessageTypeCommands>().As<IMessageTypeCommands>().InstancePerRequest();
			builder.RegisterType<SecurityByRoleCommands>().As<ISecurityByRoleCommands>().InstancePerRequest();
			builder.RegisterType<SubSecurityByRoleCommands>().As<ISubSecurityByRoleCommands>().InstancePerRequest();
			builder.RegisterType<SystemMessageCommands>().As<ISystemMessageCommands>().InstancePerRequest();
			builder.RegisterType<SystemPageTabNameCommands>().As<ISystemPageTabNameCommands>().InstancePerRequest();
			builder.RegisterType<SystemReferenceCommands>().As<ISystemReferenceCommands>().InstancePerRequest();
			builder.RegisterType<ValidationCommands>().As<IValidationCommands>().InstancePerRequest();
			builder.RegisterType<ReportCommands>().As<IReportCommands>().InstancePerRequest();
			builder.RegisterType<AppDashboardCommands>().As<IAppDashboardCommands>().InstancePerRequest();
			builder.RegisterType<SystemAccountCommands>().As<ISystemAccountCommands>().InstancePerRequest();
			builder.RegisterType<StatusLogCommands>().As<IStatusLogCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}