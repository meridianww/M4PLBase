/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 OrganizationModule
//Purpose:                                      For implementing IOC in OrganizationModule
//====================================================================================================================================================*/


using Autofac;
using M4PL.Business.Organization;

namespace M4PL.API.IoC
{
    public class OrganizationModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<OrgActRoleCommands>().As<IOrgActRoleCommands>().InstancePerRequest();
            builder.RegisterType<OrganizationCommands>().As<IOrganizationCommands>().InstancePerRequest();
            builder.RegisterType<OrgCredentialCommands>().As<IOrgCredentialCommands>().InstancePerRequest();
            builder.RegisterType<OrgFinancialCalendarCommands>().As<IOrgFinancialCalendarCommands>().InstancePerRequest();
            builder.RegisterType<OrgMarketSupportCommands>().As<IOrgMarketSupportCommands>().InstancePerRequest();
            builder.RegisterType<OrgPocContactCommands>().As<IOrgPocContactCommands>().InstancePerRequest();
            builder.RegisterType<OrgRefRoleCommands>().As<IOrgRefRoleCommands>().InstancePerRequest();
            builder.RegisterType<OrgReportCommands>().As<IOrgReportCommands>().InstancePerRequest();
            builder.RegisterType<OrgActSecurityByRoleCommands>().As<IOrgActSecurityByRoleCommands>().InstancePerRequest();
            builder.RegisterType<OrgActSubSecurityByRoleCommands>().As<IOrgActSubSecurityByRoleCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}