using System.Collections.Generic;
using M4PL.Entities;
using M4PL.Entities.Support;
using M4PL.Web.Providers;

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