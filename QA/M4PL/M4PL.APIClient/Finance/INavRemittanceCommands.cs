using M4PL.APIClient.ViewModels.NavRemittance;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient.Finance
{
    public interface INavRemittanceCommands : IBaseCommands<NavRemittanceView>
    {
        IList<NavRemittanceView> GetAllNavRemittance();
    }
}
