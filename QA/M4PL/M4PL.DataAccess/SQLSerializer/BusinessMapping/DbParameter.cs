#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Data;

namespace M4PL.DataAccess.SQLSerializer.BusinessMapping
{
    /// <summary>
    ///     Describes input parameter of stored procedure.
    ///     Parameters can be input or output.
    ///     Created By: Subin K.J               Created Date:06/10/2013
    ///     Modified By:                        Modified Date:
    /// </summary>
    public class DbParameter // <T>
    {
        #region Properties

        /// <summary>
        ///     Gets or sets parameter name
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        ///     Gets or sets parameter data type (Base dbtype)
        /// </summary>
        public DbType DataType { get; set; }

        /// <summary>
        ///     Gets or sets stored procedure parameter direction, It can be Input or output
        /// </summary>
        public ParameterDirection SPParameterDirection { get; set; }

        /// <summary>
        ///     Gets or sets value of input parameter.
        /// </summary>
        public object ParameterValue { get; set; }

        /// <summary>
        ///     Gets or sets the size of the parameter value.
        /// </summary>
        public int Size { get; set; }

        #endregion Properties
    }
}