using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
    /// <summary>
    /// Most of the values will come from Cache expects Records
    /// </summary>
    /// <typeparam name="TLabel"></typeparam>
    public class CardViewResult<TView> : ViewResult
    {
        public CardViewResult()
        {
            Records = new List<TView>();
        }
        public long RecordId { get; set; }
        public long CompanyId { get; set; }
        public IList<TView> Records { get; set; }
        public MvcRoute ReportRoute { get; set; }
        public TView Record { get; set; }

    }
}