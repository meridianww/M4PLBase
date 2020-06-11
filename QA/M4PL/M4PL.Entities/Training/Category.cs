using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Training
{
	public class Category
	{
		public string Name { get; set; }
		public IList<Video> Videos { get; set; }
	}
}
