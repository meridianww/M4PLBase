using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Administration
{
    public class ITDashboardCommands : BaseCommands<Entities.Administration.ITDashboard>
    {
        /// <summary>
        /// Gets list of Job card title
        /// </summary>
        /// <param name="companyId"></param>
        /// <returns></returns>
        public static IList<ITDashboard> GetCardTileData(ActiveUser activeUser, string DashboardName)
        {
            var parameters = new List<Parameter>()
            {
                new Parameter("@DashboardName", DashboardName)
            };

            var result = SqlSerializer.Default.DeserializeMultiRecords<ITDashboard>(StoredProceduresConstant.GetCardTileData, parameters.ToArray(), storedProcedure: true);
            return result ?? new List<ITDashboard>();
        }
    }
}
