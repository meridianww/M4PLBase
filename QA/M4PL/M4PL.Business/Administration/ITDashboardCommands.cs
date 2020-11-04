using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Administration.ITDashboardCommands;

namespace M4PL.Business.Administration
{
    public class ITDashboardCommands : BaseCommands<Entities.Administration.ITDashboard>, IITDashboardCommands
    {
        public IList<ITDashboard> GetCardTileData(string DashboardName)
        {
            var result = _commands.GetCardTileData(ActiveUser, DashboardName);
            return result;
        }

        #region Default methods
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public ITDashboard Get(long id)
        {
            throw new NotImplementedException();
        }

        public IList<ITDashboard> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            throw new NotImplementedException();
        }

        public ITDashboard Patch(ITDashboard entity)
        {
            throw new NotImplementedException();
        }

        public ITDashboard Post(ITDashboard entity)
        {
            throw new NotImplementedException();
        }

        public ITDashboard Put(ITDashboard entity)
        {
            throw new NotImplementedException();
        }
        #endregion
    }
}
