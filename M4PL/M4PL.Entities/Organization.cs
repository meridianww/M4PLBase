using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
	public class Organization
	{
		public int OrganizationID { get; set; }
		public string OrgCode { get; set; }
		public string OrgTitle { get; set; }
		public string OrgGroup { get; set; }
		public int OrgSortOrder { get; set; }
		public string OrgDesc { get; set; }
		public string OrgStatus { get; set; }
		//public DateTime OrgDateEntered { get; set; }
		public string OrgEnteredBy { get; set; }
		//public DateTime OrgDateChanged { get; set; }
		public string OrgDateChangedBy { get; set; }
	}
}