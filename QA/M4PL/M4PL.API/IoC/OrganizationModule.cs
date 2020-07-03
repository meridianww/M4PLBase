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
//Program Name:                                 OrganizationModule
//Purpose:                                      For implementing IOC in OrganizationModule
//====================================================================================================================================================*/

using Autofac;
using M4PL.Business.Organization;

namespace M4PL.API.IoC
{
	/// <summary>
	/// Organization Module
	/// </summary>
	public class OrganizationModule : Module
	{
		/// <summary>
		/// Load
		/// </summary>
		/// <param name="builder"></param>
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<OrganizationCommands>().As<IOrganizationCommands>().InstancePerRequest();
			builder.RegisterType<OrgCredentialCommands>().As<IOrgCredentialCommands>().InstancePerRequest();
			builder.RegisterType<OrgFinancialCalendarCommands>().As<IOrgFinancialCalendarCommands>().InstancePerRequest();
			builder.RegisterType<OrgMarketSupportCommands>().As<IOrgMarketSupportCommands>().InstancePerRequest();
			builder.RegisterType<OrgPocContactCommands>().As<IOrgPocContactCommands>().InstancePerRequest();
			builder.RegisterType<OrgRefRoleCommands>().As<IOrgRefRoleCommands>().InstancePerRequest();
			builder.RegisterType<OrgReportCommands>().As<IOrgReportCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}