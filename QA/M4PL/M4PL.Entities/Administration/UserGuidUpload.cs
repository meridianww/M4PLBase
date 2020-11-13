using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Administration
{
    public class UserGuidUpload : BaseModel
    {
        public string DocumentName { get; set; }
        public string Url { get; set; }
        public byte[] FileContent { get; set; }
    }
}
