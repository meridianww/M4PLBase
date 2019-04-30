/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              28/07/2018
Program Name:                                 ScnOrderRequirementCommands
Purpose:                                      Client to consume M4PL API called ScnOrderRequirementController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScnOrderRequirementCommands : BaseCommands<ViewModels.Scanner.ScnOrderRequirementView>, IScnOrderRequirementCommands
    {
        /// <summary>
        /// Route to call ScnOrderRequirement
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScnOrderRequirements"; }
        }
    }
}