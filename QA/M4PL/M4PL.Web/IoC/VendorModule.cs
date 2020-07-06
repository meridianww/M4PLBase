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
//Program Name:                                 VendorModule
//Purpose:                                      For implementing IOC in Vendor Module
//====================================================================================================================================================*/

using Autofac;
using M4PL.APIClient.Vendor;

namespace M4PL.Web.IoC
{
	public class VendorModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<VendBusinessTermCommands>().As<IVendBusinessTermCommands>().InstancePerRequest();
			builder.RegisterType<VendContactCommands>().As<IVendContactCommands>().InstancePerRequest();
			builder.RegisterType<VendDcLocationCommands>().As<IVendDcLocationCommands>().InstancePerRequest();
			builder.RegisterType<VendDcLocationContactCommands>().As<IVendDcLocationContactCommands>().InstancePerRequest();
			builder.RegisterType<VendDocReferenceCommands>().As<IVendDocReferenceCommands>().InstancePerRequest();
			builder.RegisterType<VendFinancialCalendarCommands>().As<IVendFinancialCalendarCommands>().InstancePerRequest();
			builder.RegisterType<VendorCommands>().As<IVendorCommands>().InstancePerRequest();
			builder.RegisterType<VendReportCommands>().As<IVendReportCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}