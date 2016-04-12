using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class Menus
    {
        public int MenuID { get; set; }
        [MaxLength(20)]
        public string MnuBreakDownStructure { get; set; }
        public int MnuModule { get; set; }
        [MaxLength(50)]
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
        public string MnuExecuteProgram { get; set; }
        [MaxLength(20)]
        public string MnuProgramType { get; set; }
        [MaxLength(20)]
        public string MnuClassification { get; set; }
        public int MnuOptionLevel { get; set; }
    }
}
