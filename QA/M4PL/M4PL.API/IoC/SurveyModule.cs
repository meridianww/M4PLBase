/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
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
    public class SurveyModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {
            builder.RegisterType<JobSurveyCommands>().As<IJobSurveyCommands>().InstancePerRequest();
			builder.RegisterType<SurveyUserCommands>().As<ISurveyUserCommands>().InstancePerRequest();
			base.Load(builder);
        }
    }
}