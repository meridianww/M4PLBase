using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class GridLayout
    {
        public string PageName { get; set; }
        public int UserId { get; set; }
        public string Layout { get; set; }

        public GridLayout()
        {

        }

        public GridLayout(string pageName, int userId, string layout)
        {
            this.PageName = pageName;
            this.Layout = layout;
            this.UserId = userId;
        }
    }
}
