/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 AdminModule
//Purpose:                                      For implementing IOC in Admin module
//====================================================================================================================================================*/

using Autofac;
using M4PL.APIClient.Administration;
using M4PL.APIClient.Common;

namespace M4PL.Web.IoC
{
    public class AdminModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<CommonCommands>().As<ICommonCommands>().InstancePerRequest();
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