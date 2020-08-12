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
using M4PL.Business.Common;
using M4PL.Business.Finance.CostCode;
using M4PL.Business.Finance.Customer;
using M4PL.Business.Finance.Gateway;
using M4PL.Business.Finance.NavRate;
using M4PL.Business.Finance.PriceCode;
using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Business.Finance.SalesOrder;
using M4PL.Business.Finance.Vendor;

namespace M4PL.API.IoC
{
	/// <summary>
	/// Finance Module
	/// </summary>
	public class FinanceModule : Module
	{
		/// <summary>
		/// Load
		/// </summary>
		/// <param name="builder"></param>
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<AppDashboardCommands>().As<IAppDashboardCommands>().InstancePerRequest();
			builder.RegisterType<NavVendorCommands>().As<INavVendorCommands>().InstancePerRequest();
			builder.RegisterType<NavCustomerCommands>().As<INavCustomerCommands>().InstancePerRequest();
			builder.RegisterType<NavCostCodeCommands>().As<INavCostCodeCommands>().InstancePerRequest();
			builder.RegisterType<NavPriceCodeCommands>().As<INavPriceCodeCommands>().InstancePerRequest();
			builder.RegisterType<NavSalesOrderCommands>().As<INavSalesOrderCommands>().InstancePerRequest();
			builder.RegisterType<NavPurchaseOrderCommands>().As<INavPurchaseOrderCommands>().InstancePerRequest();
			builder.RegisterType<NavRateCommands>().As<INavRateCommands>().InstancePerRequest();
			builder.RegisterType<GatewayCommands>().As<IGatewayCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}