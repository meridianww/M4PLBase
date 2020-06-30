/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 Operation
Purpose:                                      Contains objects related to Operation
==========================================================================================================*/

using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    /// <summary>
    ///
    /// </summary>
    public class Operation
    {
        public Operation()
        {
            ChildOperations = new List<Operation>();
        }

        public string LangCode { get; set; }
        public string SysRefName { get; set; }
        public string LangName { get; set; }
        public byte[] Icon { get; set; }
        public bool IsPopup { get; set; }
        public MvcRoute Route { get; set; }
        public string ClickEvent { get; set; }
        public List<Operation> ChildOperations { get; set; }
    }
}