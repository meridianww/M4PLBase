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
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              09/11/2019
//Program Name:                                 SurveyModule
//Purpose:                                      For implementing IOC in SurveyModule
//====================================================================================================================================================*/

using Autofac;
using M4PL.Business.Survey;

namespace M4PL.API.IoC
{
    /// <summary>
    /// Survey Module
    /// </summary>
    public class SurveyModule : Module
    {
        /// <summary>
        /// Load
        /// </summary>
        /// <param name="builder"></param>
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<JobSurveyCommands>().As<IJobSurveyCommands>().InstancePerRequest();
            builder.RegisterType<SurveyUserCommands>().As<ISurveyUserCommands>().InstancePerRequest();
            base.Load(builder);
        }
    }
}