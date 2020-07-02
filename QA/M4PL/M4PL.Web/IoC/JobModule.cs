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