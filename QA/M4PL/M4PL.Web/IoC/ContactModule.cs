/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ContactModule
//Purpose:                                      For implementing IOC in Contact
//====================================================================================================================================================*/

using Autofac;
using M4PL.APIClient.Contact;

namespace M4PL.Web.IoC
{
    public class ContactModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<ContactCommands>().As<IContactCommands>().InstancePerRequest();
            builder.RegisterType<ConReportCommands>().As<IConReportCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}