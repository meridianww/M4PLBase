/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 ScrServiceListView
//Purpose:                                      Represents ScrServiceListView
//====================================================================================================================================================*/

using M4PL.Entities;

namespace M4PL.APIClient.ViewModels.Scanner
{
    /// <summary>
    ///   To show details of ScrServiceList
    /// </summary>
    public class ScrServiceListView : Entities.Scanner.ScrServiceList
    {
        public DropDownViewModel PrgDropDownViewModel
        {
            get
            {
                return new DropDownViewModel { Entity = EntitiesAlias.Program, SelectedId = ProgramID, ValueType = typeof(long), ValueField = "Id", ControlName = "ServiceProgramID", PageSize = 10, TextString = "PrgProgramCode" };
            }
        }
    }
}