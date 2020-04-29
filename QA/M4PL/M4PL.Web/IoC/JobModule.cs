﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 JobModule
//Purpose:                                      For implementing IOC in Job
//====================================================================================================================================================*/

using Autofac;
using M4PL.APIClient.Job;

namespace M4PL.Web.IoC
{
    public class JobModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<JobCommands>().As<IJobCommands>().InstancePerRequest();
            builder.RegisterType<JobAttributeCommands>().As<IJobAttributeCommands>().InstancePerRequest();
            builder.RegisterType<JobCargoCommands>().As<IJobCargoCommands>().InstancePerRequest();
            builder.RegisterType<JobDocReferenceCommands>().As<IJobDocReferenceCommands>().InstancePerRequest();
            builder.RegisterType<JobGatewayCommands>().As<IJobGatewayCommands>().InstancePerRequest();
            builder.RegisterType<JobCostSheetCommands>().As<IJobCostSheetCommands>().InstancePerRequest();
            builder.RegisterType<JobBillableSheetCommands>().As<IJobBillableSheetCommands>().InstancePerRequest();
            builder.RegisterType<JobRefStatusCommands>().As<IJobRefStatusCommands>().InstancePerRequest();
            builder.RegisterType<JobReportCommands>().As<IJobReportCommands>().InstancePerRequest();
			builder.RegisterType<JobAdvanceReportCommands>().As<IJobAdvanceReportCommands>().InstancePerRequest();
			builder.RegisterType<JobEDIXcblCommands>().As<IJobEDIXcblCommands>().InstancePerRequest();
            builder.RegisterType<JobCardCommands>().As<IJobCardCommands>().InstancePerRequest();
            builder.RegisterType<JobXcblInfoCommands>().As<IJobXcblInfoCommands>().InstancePerRequest();
            builder.RegisterType<JobHistoryCommand>().As<IJobHistoryCommand>().InstancePerRequest();
            base.Load(builder);
        }
    }
}