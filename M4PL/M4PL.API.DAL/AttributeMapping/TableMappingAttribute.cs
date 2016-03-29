//------------------------------------------------------------------------------ 
// <copyright file="TableMappingAttribute.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

using System;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    /// Attribute used to map model classes to database tables and views.
    /// This attribute can only be applied to classes.
    /// All the properties of this class are read only.
    /// </summary>
    [AttributeUsage(AttributeTargets.Class)]
    public sealed class TableMappingAttribute : Attribute
    {
        #region Member varaibles

        /// <summary>
        ///     Name of table
        /// </summary>
        private string tableName;

        /// <summary>
        ///     Name of view
        /// </summary>
        private string viewName;

        /// <summary>
        ///     Primary key field of the view
        /// </summary>
        private string keyFieldName;

        #endregion

        #region Constructor

        /// <summary>
        ///		Constructor, initialize TableMappingAttribute class
        /// </summary>
        /// <param name="tableName">
        ///		Table name.
        /// </param>
        public TableMappingAttribute(string tableName)
        {
            this.tableName = tableName;
            this.viewName = tableName;
        }

        /// <summary>
        ///		Constructor, It initializes table name, view name and key field name parameters.
        /// </summary>
        /// <param name="tableName">
        ///		Table Name
        /// </param>
        /// <param name="keyFieldName">
        ///		key field name.
        /// </param>
        public TableMappingAttribute(string tableName, string keyFieldName)
        {
            this.tableName = tableName;
            this.viewName = tableName;
            this.keyFieldName = keyFieldName;
        }

        /// <summary>
        ///		Constructor, It initializes table name, view name and key field name parameters.
        /// </summary>
        /// <param name="tableName">
        ///		Name of the table
        /// </param>
        /// <param name="viewName">
        ///		Name of view
        /// </param>
        /// <param name="keyFieldName">
        ///		key field name.
        /// </param>
        public TableMappingAttribute(string tableName, string viewName, string keyFieldName)
        {
            this.tableName = tableName;
            this.viewName = viewName;
            this.keyFieldName = keyFieldName;
        }

        #endregion

        #region Properties

        /// <summary>
        /// Gets the name of the database table used for insert and update statemenPropanator.
        /// TableName is used for insert and update statemenPropanator.
        /// ViewName is used for select statements
        /// </summary>
        public string TableName
        {
            get
            {
                return this.tableName;
            }
        }

        /// <summary>
        /// Gets the name of the view or table used for select statemenPropanator.
        /// The model may be read from a view but written to a table. The view name specifies
        /// the database structure that will be queried from select statemenPropanator. If the view name
        /// is not specified, it is set to the table name.
        /// </summary>
        public string ViewName
        {
            get
            {
                return this.viewName;
            }
        }

        /// <summary>
        /// Gets the name of the model field that relates to the primary key column of the 
        /// database table.
        /// This property specifies a field name on the model class.
        /// </summary>
        public string KeyFieldName
        {
            get
            {
                return this.keyFieldName;
            }
        }

        #endregion
    }
}
