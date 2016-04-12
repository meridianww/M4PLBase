using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class disMenus
    {
        public int MenuID { get; set; }
        public string MnuBreakDownStructure { get; set; }
        public int MnuModule { get; set; }
        public string MnuTitle { get; set; }
        public string MnuDescription { get; set; }
        public string MnuTabOver { get; set; }
        public byte[] MnuIconVerySmall { get; set; }
        public byte[] MnuIconSmall { get; set; }
        public byte[] MnuIconMedium { get; set; }
        public byte[] MnuIconLarge { get; set; }
        public bool MnuRibbon { get; set; }
        public string MnuRibbonTabName { get; set; }
        public bool MnuMenuItem { get; set; }
        public string MnuExecuteProgram { get; set; }
        public string MnuProgramType { get; set; }
        public string MnuClassification { get; set; }
        public int MnuOptionLevel { get; set; }
    }
}
