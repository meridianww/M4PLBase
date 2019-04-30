/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 VendorModule
//Purpose:                                      For implementing IOC in Vendor Module
//====================================================================================================================================================*/

using Autofac;
using M4PL.APIClient.Vendor;

namespace M4PL.Web.IoC
{
    public class VendorModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<VendBusinessTermCommands>().As<IVendBusinessTermCommands>().InstancePerRequest();
            builder.RegisterType<VendContactCommands>().As<IVendContactCommands>().InstancePerRequest();
            builder.RegisterType<VendDcLocationCommands>().As<IVendDcLocationCommands>().InstancePerRequest();
            builder.RegisterType<VendDcLocationContactCommands>().As<IVendDcLocationContactCommands>().InstancePerRequest();
            builder.RegisterType<VendDocReferenceCommands>().As<IVendDocReferenceCommands>().InstancePerRequest();
            builder.RegisterType<VendFinancialCalendarCommands>().As<IVendFinancialCalendarCommands>().InstancePerRequest();
            builder.RegisterType<VendorCommands>().As<IVendorCommands>().InstancePerRequest();
            builder.RegisterType<VendReportCommands>().As<IVendReportCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}