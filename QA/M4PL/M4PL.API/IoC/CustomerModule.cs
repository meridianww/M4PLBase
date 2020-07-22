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
//Program Name:                                 CustomerModule
//Purpose:                                      For implementing IOC in CustomerModule
//====================================================================================================================================================*/

using Autofac;
using M4PL.Business.Customer;

namespace M4PL.API.IoC
{
	/// <summary>
	/// Customer Module
	/// </summary>
	public class CustomerModule : Module
	{
		/// <summary>
		/// Load
		/// </summary>
		/// <param name="builder"></param>
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<CustBusinessTermCommands>().As<ICustBusinessTermCommands>().InstancePerRequest();
			builder.RegisterType<CustContactCommands>().As<ICustContactCommands>().InstancePerRequest();
			builder.RegisterType<CustDcLocationCommands>().As<ICustDcLocationCommands>().InstancePerRequest();
			builder.RegisterType<CustDcLocationContactCommands>().As<ICustDcLocationContactCommands>().InstancePerRequest();
			builder.RegisterType<CustDocReferenceCommands>().As<ICustDocReferenceCommands>().InstancePerRequest();
			builder.RegisterType<CustFinancialCalendarCommands>().As<ICustFinancialCalendarCommands>().InstancePerRequest();
			builder.RegisterType<CustomerCommands>().As<ICustomerCommands>().InstancePerRequest();
			builder.RegisterType<CustReportCommands>().As<ICustReportCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}