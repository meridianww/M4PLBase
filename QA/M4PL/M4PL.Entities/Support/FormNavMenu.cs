/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 FormNavMenu
Purpose:                                      Contains objects related to FormNavMenu
==========================================================================================================*/
namespace M4PL.Entities.Support
{
    public class FormNavMenu : MvcRoute
    {
        public FormNavMenu()
        {
        }

        public FormNavMenu(FormNavMenu formNavMenu, bool isNext, bool isEnd, string iconId, int align, string text = null, bool enabled = true, bool secondNav = false, string itemClick = null, bool isEntityIcon = false, string cssClass = null)
        {
            Action = formNavMenu.Action;
            Entity = formNavMenu.Entity;
            Area = formNavMenu.Area;
            RecordId = formNavMenu.RecordId;
            ParentRecordId = formNavMenu.ParentRecordId;
            Filters = formNavMenu.Filters;
            IsPopup = formNavMenu.IsPopup;
            EntityName = formNavMenu.EntityName;
            Url = formNavMenu.Url;
            OwnerCbPanel = formNavMenu.OwnerCbPanel;
            ParentEntity = formNavMenu.ParentEntity;
            IsChooseColumn = formNavMenu.IsChooseColumn;
            IsNext = isNext;
            IsEnd = isEnd;
            IconID = iconId;
            Align = align;
            Text = text;
            Enabled = enabled;
            SecondNav = secondNav;
            ItemClick = itemClick;
            IsEntityIcon = isEntityIcon;
            CssClass = cssClass;
        }

        public int Align { get; set; }
        public string IconID { get; set; }
        public bool IsNext { get; set; }
        public bool IsEnd { get; set; }
        public string Text { get; set; }
        public bool Enabled { get; set; }
        public bool SecondNav { get; set; }
        public string ItemClick { get; set; }
        public bool IsEntityIcon { get; set; }
        public bool IsChooseColumn { get; set; }
        public string CssClass { get; set; }
        public long MaxID { get; set; }
        public long MinID { get; set; }
    }
}