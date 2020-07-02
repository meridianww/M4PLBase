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
// Program Name:                                 ScrCatalogListView
// Purpose:                                      Represents ScrCatalogListView
//====================================================================================================================================================

using M4PL.Entities;

namespace M4PL.APIClient.ViewModels.Scanner
{
    /// <summary>
    ///   To show details of ScrCatalogList
    /// </summary>
    public class ScrCatalogListView : Entities.Scanner.ScrCatalogList
    {
        public ScrCatalogListView()
        {
            CatalogPhotoByteArray = new Entities.Support.ByteArray() { Id = Id, FieldName = "CatalogPhoto", Bytes = CatalogPhoto, Type = Entities.SQLDataTypes.image };
        }

        public Entities.Support.ByteArray CatalogPhotoByteArray { get; set; }
        public System.Collections.Generic.IList<Entities.Support.ByteArray> FileUpload { get; set; }

        public DropDownViewModel PrgDropDownViewModel
        {
            get
            {
                return new DropDownViewModel { Entity = EntitiesAlias.Program, SelectedId = CatalogProgramID, ValueType = typeof(long), ValueField = "Id", ControlName = "CatalogProgramID", PageSize = 10, TextString = "PrgProgramCode" };
            }
        }
    }
}