//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//=================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 ColumnAliasCommands
//Purpose:                                      Client to consume M4PL API called ColumnAliasController
//===================================================================================================================

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
    /// <summary>
    /// Route to call column alias
    /// </summary>
    public class ColumnAliasCommands : BaseCommands<ColumnAliasView>,
        IColumnAliasCommands
    {
        public override string RouteSuffix
        {
            get { return "ColumnAliases"; }
        }
    }
}