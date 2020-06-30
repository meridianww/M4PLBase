/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgRoleCommands
Purpose:                                      Client to consume M4PL API called PrgRoleController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    public class PrgRoleCommands : BaseCommands<ProgramRoleView>, IPrgRoleCommands
    {
        /// <summary>
        /// Route to call PrgRoles
        /// </summary>
        public override string RouteSuffix
        {
            get { return "PrgRoles"; }
        }
    }
}