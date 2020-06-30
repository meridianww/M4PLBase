/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PageInfo
Purpose:                                      Contains objects related to PageInfo
==========================================================================================================*/

using System.Text.RegularExpressions;

namespace M4PL.Entities.Support
{
    public class PageInfo
    {
        public string RefTableName { get; set; }

        public int TabSortOrder { get; set; }

        public string TabTableName { get; set; }

        public string TabPageTitle { get; set; }

        public int StatusId { get; set; }

        public string TabExecuteProgram { get; set; }

        public byte[] TabPageIcon { get; set; }

        public MvcRoute Route { get; set; }

        public string UniqueName
        {
            get
            {
                return string.Concat(RefTableName, TabTableName, TabExecuteProgram, TabSortOrder, Regex.Replace(TabPageTitle.Replace("-", ""), @"[\s\/]", string.Empty));
            }
        }

        public bool DisabledTab { get; set; }

        public UserSubSecurity SubSecurity { get; set; }
    }
}