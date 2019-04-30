//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 ModelColumnMap
//Purpose:                                      LINQ to SQL maps a SQL Server database to a LINQ to SQL object model
//====================================================================================================================================================

using System;
using System.Data;
using System.Reflection;

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
{
    /// <summary>
    ///     The ModelColumnMap class represents an association between a field
    ///     on a model and a column in a database table.
    /// </summary>
    public class ModelColumnMap
    {
        #region Member Variables

        /// <summary>
        ///     Database field info
        /// </summary>
        private readonly FieldInfo field;

        /// <summary>
        ///     Details of column mapping attribute
        /// </summary>
        private readonly ColumnMappingAttribute columnAttribute;

        /// <summary>
        ///     Database column type.
        /// </summary>
        private readonly DbType dbType;

        /// <summary>
        ///     A boolean value indicating whether database column allow null or not.
        /// </summary>
        private readonly bool isDbTypeNull;

        /// <summary>
        ///     Details of property information.
        /// </summary>
        private readonly PropertyInfo property;

        #endregion Member Variables

        #region Constructor

        /// <summary>
        ///     Create instance of ModelColumnMap
        /// </summary>
        /// <param name="field">
        ///     The reflection information about the model's field
        /// </param>
        /// <param name="colAttr">
        ///     The column attribute associated with the field
        /// </param>
        public ModelColumnMap(FieldInfo field, ColumnMappingAttribute colAttr)
        {
            this.field = field;
            columnAttribute = colAttr;
            isDbTypeNull = false;
            if (!colAttr.IsDatabaseTypeNull)
            {
                dbType = colAttr.DatabaseType;
            }
            else
            {
                if (field.FieldType == typeof(int))
                    dbType = DbType.Int32;
                else if (field.FieldType == typeof(DateTime))
                    dbType = DbType.DateTime;
                else if (field.FieldType == typeof(string))
                    dbType = DbType.String;
                else if (field.FieldType == typeof(bool))
                    dbType = DbType.Boolean;
                else
                    isDbTypeNull = true;
            }
        }

        /// <summary>
        ///     Create instance of ModelColumnMap
        /// </summary>
        /// <param name="property">
        ///     The reflection information about the model's property
        /// </param>
        /// <param name="colAttr">
        ///     The column attribute associated with the field
        /// </param>
        public ModelColumnMap(PropertyInfo property, ColumnMappingAttribute colAttr)
        {
            this.property = property;
            columnAttribute = colAttr;
            isDbTypeNull = false;

            if (!colAttr.IsDatabaseTypeNull)
            {
                dbType = colAttr.DatabaseType;
            }
            else
            {
                if (property.PropertyType == typeof(int))
                    dbType = DbType.Int32;
                else if (property.PropertyType == typeof(DateTime))
                    dbType = DbType.DateTime;
                else if (property.PropertyType == typeof(string))
                    dbType = DbType.String;
                else if (property.PropertyType == typeof(bool))
                    dbType = DbType.Boolean;
                else
                    isDbTypeNull = true;
            }
        }

        #endregion Constructor

        #region Accessor Methods

        /// <summary>
        ///     Gets column name
        /// </summary>
        public string ColumnName
        {
            get { return columnAttribute.ColumnName; }
        }

        /// <summary>
        ///     Gets  column size
        /// </summary>
        public int ColumnSize
        {
            get { return columnAttribute.Size; }
        }

        /// <summary>
        ///     Gets a value indicating whether field is read only or not.
        /// </summary>
        public bool IsViewOnly
        {
            get { return columnAttribute.ViewOnly; }
        }

        /// <summary>
        ///     Gets field name.
        /// </summary>
        public string FieldName
        {
            get { return field.Name; }
        }

        /// <summary>
        ///     Gets property name
        /// </summary>
        public string PropertyName
        {
            get { return property.Name; }
        }

        /// <summary>
        ///     Gets field type of column
        /// </summary>
        public Type FieldType
        {
            get { return field.FieldType; }
        }

        /// <summary>
        ///     Gets property type
        /// </summary>
        public Type PropertyType
        {
            get { return property.PropertyType; }
        }

        /// <summary>
        ///     Gets field info
        /// </summary>
        public FieldInfo Field
        {
            get { return field; }
        }

        /// <summary>
        ///     Gets property info
        /// </summary>
        public PropertyInfo Property
        {
            get { return property; }
        }

        /// <summary>
        ///     Gets database type.
        /// </summary>
        public DbType DatabaseType
        {
            get { return dbType; }
        }

        /// <summary>
        ///     Gets a value indicating whether database type is null or not.
        /// </summary>
        public bool IsDatabaseTypeNull
        {
            get { return isDbTypeNull; }
        }

        #endregion Accessor Methods
    }
}