//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 ColumnMappingAttribute
//Purpose:                                      LINQ to SQL maps a SQL Server database to a LINQ to SQL object model
//====================================================================================================================================================

using System;
using System.Data;

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
{
    /// <summary>
    ///     Attribute used to map value object fields and properties to database columns.
    ///     This attribute can only be applied to fields.
    ///     All the properties of this class are read only.
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class ColumnMappingAttribute : Attribute
    {
        #region Member Variables

        /// <summary>
        ///     Database column name
        /// </summary>
        private readonly string columnName;

        /// <summary>
        ///     Size of data type
        /// </summary>
        private readonly int size;

        /// <summary>
        ///     Indicating filed is read only field or not.
        /// </summary>
        private readonly bool viewOnly;

        /// <summary>
        ///     Data type of the column
        /// </summary>
        private readonly object dbType = null;

        #endregion Member Variables

        #region Methods

        /// <summary>
        ///     Construct a column mapping attribute.
        /// </summary>
        /// <param name="columnName">
        ///     The name of the database column
        /// </param>
        /// <param name="viewOnly">
        ///     true if the field is for viewing only,
        ///     false if the field can be modified by inserts and updates
        /// </param>
        public ColumnMappingAttribute(string columnName, bool viewOnly)
        {
            this.columnName = columnName;
            this.viewOnly = viewOnly;
        }

        /// <summary>
        ///     Construct a column mapping attribute.
        /// </summary>
        /// <param name="columnName">
        ///     The name of the database column
        /// </param>
        /// <param name="size">
        ///     The size of this column in the database
        /// </param>
        /// <param name="viewOnly">
        ///     true if the field is for viewing only,
        ///     false if the field can be modified by inserts and updates
        /// </param>
        public ColumnMappingAttribute(string columnName, int size, bool viewOnly)
        {
            this.columnName = columnName;
            this.size = size;
            this.viewOnly = viewOnly;
        }

        #endregion Methods

        #region Accessor Methods

        /// <summary>
        ///     Gets database column name.
        ///     This property specifies the column in the database table that is related to the
        ///     field in the model.
        /// </summary>
        public string ColumnName
        {
            get { return columnName; }
        }

        /// <summary>
        ///     Gets database column size
        ///     Size is an optional field that may be specified on certain data types, like strings
        ///     for example, to specify the database size of the column.
        /// </summary>
        public int Size
        {
            get { return size; }
        }

        /// <summary>
        ///     Gets a value indicating whether column is read only or not.
        ///     This property is true if the field is for viewing purposes only and cannot be
        ///     saved to the database. This property is false if the field can be modified through
        ///     inserts and updates.
        /// </summary>
        public bool ViewOnly
        {
            get { return viewOnly; }
        }

        /// <summary>
        ///     Gets  database type
        /// </summary>
        public DbType DatabaseType
        {
            get { return (DbType)dbType; }
        }

        /// <summary>
        ///     Gets a value indicating whether db type is null or not.
        /// </summary>
        public bool IsDatabaseTypeNull
        {
            get { return dbType == null; }
        }

        #endregion Accessor Methods
    }
}