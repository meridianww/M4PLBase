//------------------------------------------------------------------------------ 
// <copyright file="ModelColumnMap.cs" company="Dream-Orbit">
//     Copyright (c) Dream-Orbit Software Technologies.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------ 

using System;
using System.Data;
using System.Reflection;

namespace M4PL.DataAccess.Models.Mapping
{
    /// <summary>
    /// The ModelColumnMap class represents an association between a field
    /// on a model and a column in a database table.
    /// </summary>
    public class ModelColumnMap
    {
        #region Member Variables

        /// <summary>
        ///     Database field info
        /// </summary>
        private FieldInfo field;

        /// <summary>
        ///     Details of column mapping attribute
        /// </summary>
        private ColumnMappingAttribute columnAttribute;

        /// <summary>
        ///     Database column type.
        /// </summary>
        private DbType dbType;

        /// <summary>
        ///     A boolean value indicating whether database column allow null or not.
        /// </summary>
        private bool isDbTypeNull;

        /// <summary>
        ///     Details of property information.
        /// </summary>
        private PropertyInfo property;

        #endregion

        #region Constructor

        /// <summary>
        ///		Create instance of ModelColumnMap
        /// </summary>
        /// <param name="field">
        ///		The reflection information about the model's field
        /// </param>
        /// <param name="colAttr">
        ///		The column attribute associated with the field
        /// </param>
        public ModelColumnMap(FieldInfo field, ColumnMappingAttribute colAttr)
        {
            this.field = field;
            this.columnAttribute = colAttr;
            this.isDbTypeNull = false;
            if (!colAttr.IsDatabaseTypeNull)
            {
                this.dbType = colAttr.DatabaseType;
            }
            else
            {
                if (field.FieldType == typeof(int))
                {
                    // field.FieldType == typeof(IntClass) ||
                    this.dbType = DbType.Int32;
                }
                else if (field.FieldType == typeof(DateTime))
                {
                    // field.FieldType == typeof(DateClass) ||
                    this.dbType = DbType.DateTime;
                }
                else if (field.FieldType == typeof(string))
                {
                    this.dbType = DbType.String;
                }
                else if (field.FieldType == typeof(bool))
                {
                    this.dbType = DbType.Boolean;
                }
                else
                {
                    this.isDbTypeNull = true;
                }
            }
        }

        /// <summary>
        ///		Create instance of ModelColumnMap
        /// </summary>
        /// <param name="property">
        ///		The reflection information about the model's property
        /// </param>
        /// <param name="colAttr">
        ///		The column attribute associated with the field
        /// </param>
        public ModelColumnMap(PropertyInfo property, ColumnMappingAttribute colAttr)
        {
            this.property = property;
            this.columnAttribute = colAttr;
            this.isDbTypeNull = false;

            if (!colAttr.IsDatabaseTypeNull)
            {
                this.dbType = colAttr.DatabaseType;
            }
            else
            {
                if (property.PropertyType == typeof(int))
                {
                    // property.PropertyType  == typeof(IntClass) ||
                    this.dbType = DbType.Int32;
                }
                else if (property.PropertyType == typeof(DateTime))
                {
                    // property.PropertyType == typeof(DateClass) ||
                    this.dbType = DbType.DateTime;
                }
                else if (property.PropertyType == typeof(string))
                {
                    this.dbType = DbType.String;
                }
                else if (property.PropertyType == typeof(bool))
                {
                    this.dbType = DbType.Boolean;
                }
                else
                {
                    this.isDbTypeNull = true;
                }
            }
        }

        #endregion

        #region Accessor Methods

        /// <summary>
        ///		Gets column name
        /// </summary>
        public string ColumnName
        {
            get
            {
                return this.columnAttribute.ColumnName;
            }
        }

        /// <summary>
        ///		Gets  column size
        /// </summary>
        public int ColumnSize
        {
            get
            {
                return this.columnAttribute.Size;
            }
        }

        /// <summary>
        ///		Gets a value indicating whether field is read only or not.
        /// </summary>
        public bool IsViewOnly
        {
            get
            {
                return this.columnAttribute.ViewOnly;
            }
        }

        /// <summary>
        ///		Gets field name.
        /// </summary>
        public string FieldName
        {
            get
            {
                return this.field.Name;
            }
        }

        /// <summary>
        ///		Gets property name
        /// </summary>
        public string PropertyName
        {
            get
            {
                return this.property.Name;
            }
        }

        /// <summary>
        ///		Gets field type of column
        /// </summary>
        public Type FieldType
        {
            get
            {
                return this.field.FieldType;
            }
        }

        /// <summary>
        ///		Gets property type
        /// </summary>
        public Type PropertyType
        {
            get
            {
                return this.property.PropertyType;
            }
        }

        /// <summary>
        ///		Gets field info
        /// </summary>
        public FieldInfo Field
        {
            get
            {
                return this.field;
            }
        }

        /// <summary>
        ///		Gets property info
        /// </summary>
        public PropertyInfo Property
        {
            get
            {
                return this.property;
            }
        }

        /// <summary>
        ///		Gets database type.
        /// </summary>
        public DbType DatabaseType
        {
            get
            {
                return (DbType)this.dbType;
            }
        }

        /// <summary>
        ///		Gets a value indicating whether database type is null or not.
        /// </summary>
        public bool IsDatabaseTypeNull
        {
            get
            {
                return this.isDbTypeNull;
            }
        }

        #endregion
    }
}
