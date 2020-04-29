/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 DropDownViewModel
//Purpose:                                      Represents DropDownViewModel Details
//====================================================================================================================================================*/

using System;

namespace M4PL.APIClient.ViewModels
{
    public class DropDownViewModel
    {
        public Entities.EntitiesAlias Entity { get; set; }
        public Entities.EntitiesAlias EntityFor { get; set; }
        public Entities.EntitiesAlias ParentEntity { get; set; }
        public object SelectedId { get; set; }
        public object ParentId { get; set; }
        public string ValueField { get; set; }
        public string ControlName { get; set; }
        public string ControlCaption { get; set; }
        public Type ValueType { get; set; }
        public bool IsEditable { get; set; }
        public bool Disabled { get; set; }
        public bool HideLabel { get; set; }
        public string TextString { get; set; }
        public int PageSize { get; set; }
        public bool IsPopup { get; set; }
        public string ParentCondition { get; set; }
        public string ValueChangedEvent { get; set; }
        public string BeginCallBack { get; set; }
        public bool IsReadOnly { get; set; }
        public string MaxLengthField { get; set; }
        public bool ClientNotVisible { get; set; }
        public bool IsRequired { get; set; }
        public string OnInit { get; set; }
        public string LostFocus { get; set; }
        public bool HideClearButton { get; set; }
        public bool PopupHorizontalAlignRight { get; set; }
        public string NameSuffix { get; set; }
        public bool Filter { get; set; }
		public long? CompanyId { get; set; }
        public string JobSiteCode { get; set; }
        public bool IsRequiredAll { get; set; }
        public string ProgramIdCode { get; set; }
        public string SelectedCountry { get; set; }
        public string GatewayAction { get; set; }
    }

    public class IntDropDownViewModel : DropDownViewModel
    {
        public Type ParentValueType { get; set; }
        public new int SelectedId { get; set; }
    }
}