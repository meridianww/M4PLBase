using M4PL.APIClient.ViewModels.Administration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient.Administration
{
    public interface IITDashboardCommands : IBaseCommands<ITDashboardView>
    {
        IList<ITDashboardView> GetCardTileData(string dashboardName);
    }
}
