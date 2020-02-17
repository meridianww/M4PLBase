using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobCardTileDetail : BaseModel
    {
        public long CardCount { get; set; }
        public string Name { get; set; }
        public string CardType { get; set; }
    }
}
