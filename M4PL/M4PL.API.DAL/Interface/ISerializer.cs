using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.DataAccess.Serializer;

namespace M4PL.DataAccess.Interface
{
    /// <summary>
    ///
    /// </summary>
    public interface ISerializer
    {
        #region Serializer

        /// <summary>
        /// Get Sql serializer for
        /// </summary>
        SqlSerializer DAL
        {
            get;
        }

        #endregion
    }
}
