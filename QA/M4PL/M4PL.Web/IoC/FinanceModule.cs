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
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              10/03/2019
//Program Name:                                 FinanceModule
//Purpose:                                      For implementing IOC in Finance Module
//====================================================================================================================================================*/
using Autofac;
using M4PL.APIClient.Common;
using M4PL.APIClient.Finance;

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
			builder.RegisterType<NavRateCommands>().As<INavRateCommands>().InstancePerRequest();
			builder.RegisterType<GatewayCommands>().As<IGatewayCommands>().InstancePerRequest();
			builder.RegisterType<NavRemittanceCommands>().As<INavRemittanceCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}