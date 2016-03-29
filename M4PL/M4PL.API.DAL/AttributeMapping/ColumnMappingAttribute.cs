//------------------------------------------------------------------------------ 
// <copyright file="SampleDataset.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Data;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    /// Attribute used to map value object fields and properties to database columns.
    /// This attribute can only be applied to fields.
    /// All the properties of this class are read only.
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class ColumnMappingAttribute : Attribute
    {
        #region Member Variables

        /// <summary>
        ///     Database column name
        /// </summary>
        private string columnName;

        /// <summary>
        ///     Size of data type
        /// </summary>
        private int size;

        /// <summary>
        ///     Indicating filed is read only field or not.
        /// </summary>
        private bool viewOnly;

        /// <summary>
        ///     Data type of the column
        /// </summary>
        private object dbType = null;

        #endregion

        #region Methods

        /// <summary>
        ///		Construct a column mapping attribute.
        /// </summary>
        /// <param name="columnName">
        ///		The name of the database column
        /// </param>
        /// <param name="viewOnly">
        ///		true if the field is for viewing only,
        ///		false if the field can be modified by inserts and updates
        /// </param>
        public ColumnMappingAttribute(string columnName, bool viewOnly)
        {
            this.columnName = columnName;
            this.viewOnly = viewOnly;
        }

        /// <summary>
        ///		Construct a column mapping attribute.
        /// </summary>
        /// <param name="columnName">
        ///		The name of the database column
        /// </param>
        /// <param name="size">
        ///		The size of this column in the database
        /// </param>
        /// <param name="viewOnly">
        ///		true if the field is for viewing only,
        ///		false if the field can be modified by inserts and updates
        /// </param>
        public ColumnMappingAttribute(string columnName, int size, bool viewOnly)
        {
            this.columnName = columnName;
            this.size = size;
            this.viewOnly = viewOnly;
        }

        #endregion

        #region Accessor Methods

        /// <summary>
        ///     Gets database column name.
        ///		This property specifies the column in the database table that is related to the
        ///		field in the model.
        /// </summary>
        public string ColumnName
        {
            get
            {
                return this.columnName;
            }
        }

        /// <summary>
        ///     Gets database column size
        ///		Size is an optional field that may be specified on certain data types, like strings
        ///		for example, to specify the database size of the column.
        /// </summary>
        public int Size
        {
            get
            {
                return this.size;
            }
        }

        /// <summary>
        ///     Gets a value indicating whether column is read only or not.
        ///		This property is true if the field is for viewing purposes only and cannot be 
        ///		saved to the database. This property is false if the field can be modified through
        ///		inserts and updates.
        /// </summary>
        public bool ViewOnly
        {
            get
            {
                return this.viewOnly;
            }
        }

        /// <summary>
        ///		Gets  database type
        /// </summary>
        public DbType DatabaseType
        {
            get
            {
                return (DbType)this.dbType;
            }
        }

        /// <summary>
        ///		Gets a value indicating whether db type is null or not.
        /// </summary>
        public bool IsDatabaseTypeNull
        {
            get
            {
                return this.dbType == null;
            }
        }

        #endregion
    }
}
