#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using Autofac;
using M4PL.Business.XCBL;


namespace M4PL.API.IoC
{
    /// <summary>
    /// XcblModule
    /// </summary>
	public class XcblModule : Module
    {
        /// <summary>
        /// Load
        /// </summary>
        /// <param name="builder"></param>
		protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<XCBLCommands>().As<IXCBLCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}