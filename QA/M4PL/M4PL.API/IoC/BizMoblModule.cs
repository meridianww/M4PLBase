#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using Autofac;
using M4PL.Business.Administration;
using M4PL.Business.BizMobl;
using M4PL.Business.Common;

namespace M4PL.API.IoC
{
	public class BizMoblModule : Module
	{
		protected override void Load(ContainerBuilder builder)
		{
			builder.RegisterType<BizMoblCommands>().As<IBizMoblCommands>().InstancePerRequest();
			base.Load(builder);
		}
	}
}