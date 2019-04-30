using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              05/29/2018
Program Name:                                 Contact Combobox
Purpose:                                      Contains objects related to Contact Combobox
==========================================================================================================*/


namespace M4PL.Entities.Support
{
    public class ContactComboBox
    {
        public long Id { get; set; }
        public string ConFullName { get; set; }
        public string ConJobTitle { get; set; }
        public string ConOrgIdName { get; set; }
        public string ConFileAs { get; set; }
        public int StatusId { get; set; }
    }
}
