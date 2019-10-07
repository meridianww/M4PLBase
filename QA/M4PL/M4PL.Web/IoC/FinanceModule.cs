/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              10/03/2019
//Program Name:                                 FinanceModule
//Purpose:                                      For implementing IOC in Finance Module
//====================================================================================================================================================*/
using Autofac;
using M4PL.APIClient.Finance;
using M4PL.APIClient.Common;

namespace M4PL.Web.IoC
{
	public class FinanceModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<CommonCommands>().As<ICommonCommands>().InstancePerRequest();
			builder.RegisterType<AppDashboardCommands>().As<IAppDashboardCommands>().InstancePerRequest();
			builder.RegisterType<NavCustomerCommands>().As<INavCustomerCommands>().InstancePerRequest();
			builder.RegisterType<NavVendorCommands>().As<INavVendorCommands>().InstancePerRequest();
			builder.RegisterType<NavCostCodeCommands>().As<INavCostCodeCommands>().InstancePerRequest();
			builder.RegisterType<NavPriceCodeCommands>().As<INavPriceCodeCommands>().InstancePerRequest();
			builder.RegisterType<NavSalesOrderCommands>().As<INavSalesOrderCommands>().InstancePerRequest();
			builder.RegisterType<NavPurchaseOrderCommands>().As<INavPurchaseOrderCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}