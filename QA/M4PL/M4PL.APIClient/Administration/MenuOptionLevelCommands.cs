/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 MenuOptionLevelCommands
Purpose:                                      Client to consume M4PL API called MenuOptionLevelController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    public class MenuOptionLevelCommands : BaseCommands<MenuOptionLevelView>, IMenuOptionLevelCommands
    {
        /// <summary>
        /// Route to call MenuOptionLevels
        /// </summary>
        public override string RouteSuffix
        {
            get { return "MenuOptionLevels"; }
        }
    }
}