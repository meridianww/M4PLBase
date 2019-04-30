/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ScannerModule
//Purpose:                                      For implementing IOC in ScannerModule
//====================================================================================================================================================*/

using Autofac;
using M4PL.Business.Scanner;

namespace M4PL.API.IoC
{
    public class ScannerModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<ScrCatalogListCommands>().As<IScrCatalogListCommands>().InstancePerRequest();
            builder.RegisterType<ScrOsdListCommands>().As<IScrOsdListCommands>().InstancePerRequest();
            builder.RegisterType<ScrOsdReasonListCommands>().As<IScrOsdReasonListCommands>().InstancePerRequest();
            builder.RegisterType<ScrRequirementListCommands>().As<IScrRequirementListCommands>().InstancePerRequest();
            builder.RegisterType<ScrReturnReasonListCommands>().As<IScrReturnReasonListCommands>().InstancePerRequest();
            builder.RegisterType<ScrServiceListCommands>().As<IScrServiceListCommands>().InstancePerRequest();
            builder.RegisterType<ScrReportCommands>().As<IScrReportCommands>().InstancePerRequest();

            builder.RegisterType<ScnOrderCommands>().As<IScnOrderCommands>().InstancePerRequest();
            builder.RegisterType<ScnCargoCommands>().As<IScnCargoCommands>().InstancePerRequest();
            builder.RegisterType<ScnCargoDetailCommands>().As<IScnCargoDetailCommands>().InstancePerRequest();
            builder.RegisterType<ScnOrderServiceCommands>().As<IScnOrderServiceCommands>().InstancePerRequest();
            builder.RegisterType<ScrInfoListCommands>().As<IScrInfoListCommands>().InstancePerRequest();
            builder.RegisterType<ScnRouteListCommands>().As<IScnRouteListCommands>().InstancePerRequest();
            builder.RegisterType<ScnDriverListCommands>().As<IScnDriverListCommands>().InstancePerRequest();
            builder.RegisterType<ScnOrderRequirementCommands>().As<IScnOrderRequirementCommands>().InstancePerRequest();
            builder.RegisterType<ScrGatewayListCommands>().As<IScrGatewayListCommands>().InstancePerRequest();
            builder.RegisterType<ScnOrderOSDCommands>().As<IScnOrderOSDCommands>().InstancePerRequest();

            base.Load(builder);
        }
    }
}