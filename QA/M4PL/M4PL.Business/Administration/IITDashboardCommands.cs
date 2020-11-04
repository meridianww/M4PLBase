using M4PL.Entities.Administration;
using System.Collections.Generic;

namespace M4PL.Business.Administration
{
    public interface IITDashboardCommands : IBaseCommands<Entities.Administration.ITDashboard>
    {
        IList<ITDashboard> GetCardTileData(string DashboardName);
    }
}
