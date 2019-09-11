/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 AdminModule
//Purpose:                                      For implementing IOC in Admin module
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
			base.Load(builder);
        }
    }
}