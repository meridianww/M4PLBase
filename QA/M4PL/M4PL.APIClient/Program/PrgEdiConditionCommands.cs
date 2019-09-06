/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Nikhil
Date Programmed:                              08/21/2019
Program Name:                                 PrgEdiConditionCommands
Purpose:                                      Client to consume M4PL API called PrgEdiConditionsController
=============================================================================================================*/
using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    public class PrgEdiConditionCommands : BaseCommands<PrgEdiConditionView>, IPrgEdiConditionCommands
    {
        /// <summary>
        /// Route to call PrgEdiCondition
        /// </summary>
        public override string RouteSuffix
        {
            get { return "PrgEdiConditions"; }
        }
    }
}
