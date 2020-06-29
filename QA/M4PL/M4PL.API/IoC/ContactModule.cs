/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ContactModule
//Purpose:                                      For implementing IOC in ContactModule
//====================================================================================================================================================*/


using Autofac;
using M4PL.Business.Contact;

namespace M4PL.API.IoC
{
    /// <summary>
    /// Contact Module
    /// </summary>
    public class ContactModule : Module
    {
        /// <summary>
        /// Load
        /// </summary>
        /// <param name="builder"></param>
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<ContactCommands>().As<IContactCommands>().InstancePerRequest();
            builder.RegisterType<ConReportCommands>().As<IConReportCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}