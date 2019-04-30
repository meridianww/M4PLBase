/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 ScrCatalogListView
//Purpose:                                      Represents ScrCatalogListView
//====================================================================================================================================================*/

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