/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CustomerModule
//Purpose:                                      For implementing IOC in Customer
//====================================================================================================================================================*/

using Autofac;
using M4PL.APIClient.Customer;

namespace M4PL.Web.IoC
{
    public class CustomerModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<CustBusinessTermCommands>().As<ICustBusinessTermCommands>().InstancePerRequest();
            builder.RegisterType<CustContactCommands>().As<ICustContactCommands>().InstancePerRequest();
            builder.RegisterType<CustDcLocationCommands>().As<ICustDcLocationCommands>().InstancePerRequest();
            builder.RegisterType<CustDcLocationContactCommands>().As<ICustDcLocationContactCommands>().InstancePerRequest();
            builder.RegisterType<CustDocReferenceCommands>().As<ICustDocReferenceCommands>().InstancePerRequest();
            builder.RegisterType<CustFinancialCalendarCommands>().As<ICustFinancialCalendarCommands>().InstancePerRequest();
            builder.RegisterType<CustomerCommands>().As<ICustomerCommands>().InstancePerRequest();
            builder.RegisterType<CustReportCommands>().As<ICustReportCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}