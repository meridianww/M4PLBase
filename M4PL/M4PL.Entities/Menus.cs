//    Copyright (2016) Meridian Worldwide Transportation Group
//    All Rights Reserved Worldwide
//    ====================================================================================================================================================
//    Program Title:                                Meridian 4th Party Logistics(M4PL)
//    Programmer:                                   Janardana
//    Date Programmed:                              15/4/2016
//    Program Name:                                 _OrganisationChangedAndEnteredFormPartial
//    Purpose:                                      Contains classes related to Menus 

//    ====================================================================================================================================================

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class Menus : MenuLabels
    {
        public int MenuID { get; set; }
        [MaxLength(20)]
        [Required(ErrorMessage = "Please enter Menu breakdown structure", AllowEmptyStrings = false)]
        public string MnuBreakDownStructure { get; set; }
        [Required(ErrorMessage = "Please select Menu module", AllowEmptyStrings = false)]
        public int? MnuModule { get; set; }
        [MaxLength(50)]
        [Required(ErrorMessage = "Please enter Menu title", AllowEmptyStrings = false)]
        public string MnuTitle { get; set; }
        public string MnuDescription { get; set; }
        [MaxLength(25)]
        public string MnuTabOver { get; set; }
        public byte[] MnuIconVerySmall { get; set; }
        public byte[] MnuIconSmall { get; set; }
        public byte[] MnuIconMedium { get; set; }
        public byte[] MnuIconLarge { get; set; }
        public bool MnuRibbon { get; set; }
        [MaxLength(255)]
        public string MnuRibbonTabName { get; set; }
        public bool MnuMenuItem { get; set; }
        [MaxLength(255)]
        [Required(ErrorMessage = "Please enter Menu execute program", AllowEmptyStrings = false)]
        public string MnuExecuteProgram { get; set; }
        [MaxLength(20)]
        [Required(ErrorMessage = "Please select Program type", AllowEmptyStrings = false)]
        public string MnuProgramType { get; set; }
        [MaxLength(20)]
        public string MnuClassification { get; set; }
        public int? MnuOptionLevel { get; set; }

        //Display images
        public List<byte> LstIconVerySmall { get; set; }
        public List<byte> LstIconSmall { get; set; }
        public List<byte> LstIconMedium { get; set; }
        public List<byte> LstIconLarge { get; set; }

        public DateTime MnuDateEntered { get; set; }

        public DateTime MnuDateChanged { get; set; }

        public string MnuEnteredBy { get; set; }

        public string MnuChangedBy { get; set; }
    }

    public class MenuLabels
    {
        public string LblMenuID { get; set; }
        public string LblMnuBreakDownStructure { get; set; }
        public string LblMnuModule { get; set; }
        public string LblMnuTitle { get; set; }
        public string LblMnuDescription { get; set; }
        public string LblMnuTabOver { get; set; }
        public string LblMnuIconVerySmall { get; set; }
        public string LblMnuIconSmall { get; set; }
        public string LblMnuIconMedium { get; set; }
        public string LblMnuIconLarge { get; set; }
        public string LblMnuRibbon { get; set; }
        public string LblMnuRibbonTabName { get; set; }
        public string LblMnuMenuItem { get; set; }
        public string LblMnuExecuteProgram { get; set; }
        public string LblMnuProgramType { get; set; }
        public string LblMnuClassification { get; set; }
        public string LblMnuOptionLevel { get; set; }
        public string LblMnuDateEntered { get; set; }
        public string LblMnuDateChanged { get; set; }
        public string LblMnyDateEnteredBy { get; set; }
        public string LblMnuDateChangedBy { get; set; }
    }
}
