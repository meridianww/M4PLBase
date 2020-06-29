/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 AttachmentModule
//Purpose:                                      For implementing IOC in AttachmentModule
//====================================================================================================================================================*/

using Autofac;
using M4PL.Business.Attachment;

namespace M4PL.API.IoC
{
    /// <summary>
    /// Attachment Module
    /// </summary>
    public class AttachmentModule : Module
    {
        /// <summary>
        /// Load
        /// </summary>
        /// <param name="builder"></param>
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<AttachmentCommands>().As<IAttachmentCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}