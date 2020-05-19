/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ProgramModule
//Purpose:                                      For implementing IOC in ProgramModule
//====================================================================================================================================================*/

using Autofac;
using M4PL.Business.Program;

namespace M4PL.API.IoC
{
    /// <summary>
    /// Program Module
    /// </summary>
    public class ProgramModule : Module
    {
        /// <summary>
        /// Load
        /// </summary>
        /// <param name="builder"></param>
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<PrgRefAttributeDefaultCommands>().As<IPrgRefAttributeDefaultCommands>().InstancePerRequest();
            builder.RegisterType<PrgRefGatewayDefaultCommands>().As<IPrgRefGatewayDefaultCommands>().InstancePerRequest();
            builder.RegisterType<PrgShipApptmtReasonCodeCommands>().As<IPrgShipApptmtReasonCodeCommands>().InstancePerRequest();
            builder.RegisterType<PrgShipStatusReasonCodeCommands>().As<IPrgShipStatusReasonCodeCommands>().InstancePerRequest();
            builder.RegisterType<PrgBillableRateCommands>().As<IPrgBillableRateCommands>().InstancePerRequest();
            builder.RegisterType<ProgramCommands>().As<IProgramCommands>().InstancePerRequest();
            builder.RegisterType<PrgCostRateCommands>().As<IPrgCostRateCommands>().InstancePerRequest();
            builder.RegisterType<PrgRoleCommands>().As<IPrgRoleCommands>().InstancePerRequest();
            builder.RegisterType<PrgEdiHeaderCommands>().As<IPrgEdiHeaderCommands>().InstancePerRequest();
            builder.RegisterType<PrgEdiMappingCommands>().As<IPrgEdiMappingCommands>().InstancePerRequest();
            builder.RegisterType<PrgVendLocationCommands>().As<IPrgVendLocationCommands>().InstancePerRequest();
            builder.RegisterType<PrgMvocCommands>().As<IPrgMvocCommands>().InstancePerRequest();
            builder.RegisterType<PrgMvocRefQuestionCommands>().As<IPrgMvocRefQuestionCommands>().InstancePerRequest();
            builder.RegisterType<PrgReportCommands>().As<IPrgReportCommands>().InstancePerRequest();
            builder.RegisterType<PrgCostLocationCommands>().As<IPrgCostLocationCommands>().InstancePerRequest();
            builder.RegisterType<PrgBillableLocationCommands>().As<IPrgBillableLocationCommands>().InstancePerRequest();
            builder.RegisterType<PrgEdiConditionCommands>().As<IPrgEdiConditionCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}