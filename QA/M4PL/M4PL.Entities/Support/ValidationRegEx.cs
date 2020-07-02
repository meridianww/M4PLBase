#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ColumnValidation
// Purpose:                                      Contains objects related to ColumnValidation
//==========================================================================================================

namespace M4PL.Entities.Support
{
    /// <summary>
    ///  sets validation for the column of the selected table
    /// </summary>
    public class ValidationRegEx
    {
        public string ValFieldName { get; set; }
        public int? ValRegExLogic0 { get; set; }
        public string ValRegEx1 { get; set; }
        public string ValRegExMessage1 { get; set; }
        public int? ValRegExLogic1 { get; set; }
        public string ValRegEx2 { get; set; }
        public string ValRegExMessage2 { get; set; }
        public int? ValRegExLogic2 { get; set; }
        public string ValRegEx3 { get; set; }
        public string ValRegExMessage3 { get; set; }
        public int? ValRegExLogic3 { get; set; }
        public string ValRegEx4 { get; set; }
        public string ValRegExMessage4 { get; set; }
        public int? ValRegExLogic4 { get; set; }
        public string ValRegEx5 { get; set; }
        public string ValRegExMessage5 { get; set; }
    }
}