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
//Program Name:                                 ScannerModule
//Purpose:                                      For implementing IOC in ScannerModule
//====================================================================================================================================================*/

using Autofac;
using M4PL.Business.Scanner;

namespace M4PL.API.IoC
{
	/// <summary>
	/// ScannerModule
	/// </summary>
	public class ScannerModule : Module
	{
		/// <summary>
		/// Load
		/// </summary>
		/// <param name="builder"></param>
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