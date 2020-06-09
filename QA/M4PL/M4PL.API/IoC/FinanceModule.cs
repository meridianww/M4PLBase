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
using M4PL.Business.Common;
using M4PL.Business.Finance.CostCode;
using M4PL.Business.Finance.Customer;
using M4PL.Business.Finance.PriceCode;
using M4PL.Business.Finance.PurchaseOrder;
using M4PL.Business.Finance.SalesOrder;
using M4PL.Business.Finance.Vendor;

namespace M4PL.API.IoC
{
    public class FinanceModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<AppDashboardCommands>().As<IAppDashboardCommands>().InstancePerRequest();
            builder.RegisterType<NavVendorCommands>().As<INavVendorCommands>().InstancePerRequest();
            builder.RegisterType<NavCustomerCommands>().As<INavCustomerCommands>().InstancePerRequest();
            builder.RegisterType<NavCostCodeCommands>().As<INavCostCodeCommands>().InstancePerRequest();
            builder.RegisterType<NavPriceCodeCommands>().As<INavPriceCodeCommands>().InstancePerRequest();
            builder.RegisterType<NavSalesOrderCommands>().As<INavSalesOrderCommands>().InstancePerRequest();
            builder.RegisterType<NavPurchaseOrderCommands>().As<INavPurchaseOrderCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}