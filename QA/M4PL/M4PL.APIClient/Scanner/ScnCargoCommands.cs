/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              28/07/2018
Program Name:                                 ScnCargoCommands
Purpose:                                      Client to consume M4PL API called ScnCargoController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScnCargoCommands : BaseCommands<ViewModels.Scanner.ScnCargoView>, IScnCargoCommands
    {
        /// <summary>
        /// Route to call ScrCatalogList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScnCargos"; }
        }
    }
}