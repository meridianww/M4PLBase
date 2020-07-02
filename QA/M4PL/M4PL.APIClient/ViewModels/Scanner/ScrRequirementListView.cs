#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              13/10/2017
// Program Name:                                 ScrRequirementListView
// Purpose:                                      Represents ScrRequirementListView
//====================================================================================================================================================

using M4PL.Entities;

namespace M4PL.APIClient.ViewModels.Scanner
{
    /// <summary>
    ///   To show details of ScrRequirementList
    /// </summary>
    public class ScrRequirementListView : Entities.Scanner.ScrRequirementList
    {
        public DropDownViewModel PrgDropDownViewModel
        {
            get
            {
                return new DropDownViewModel { Entity = EntitiesAlias.Program, SelectedId = ProgramID, ValueType = typeof(long), ValueField = "Id", ControlName = "RequirementProgramID", PageSize = 10, TextString = "PrgProgramCode" };
            }
        }
    }
}