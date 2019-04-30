//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 ModelDataMap
//Purpose:                                      LINQ to SQL maps a SQL Server database to a LINQ to SQL object model
//====================================================================================================================================================

using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

namespace M4PL.DataAccess.SQLSerializer.AttributeMapping
{
    /// <summary>
    ///     Class used for attribute mapping
    /// </summary>
    public class ModelDataMap
    {
        #region Constructor

        /// <summary>
        ///     Creates instance of ModelDataMap
        /// </summary>
        /// <param name="modelType">
        ///     Type of model object.
        /// </param>
        private ModelDataMap(Type modelType)
        {
            this.modelType = modelType;
            constructor = modelType.GetConstructor(Type.EmptyTypes);

            SetTableAttribute();
            CreateColumnMapping();
            SetProcedureAttribute();
            CreateParameterMapping();
        }

        #endregion Constructor

        #region Member Variables

        /// <summary>
        ///     Details of model type
        /// </summary>
        private readonly Type modelType;

        /// <summary>
        ///     Constructor info for invoking constructor of model
        /// </summary>
        private readonly ConstructorInfo constructor;

        /// <summary>
        ///     Details of mapping tables
        /// </summary>
        private static Hashtable mappingTable;

        /// <summary>
        ///     Details of table mapping attribute.
        /// </summary>
        private TableMappingAttribute tableAttribute;

        /// <summary>
        ///     Name of primary key column
        /// </summary>
        private string keyColumn;

        /// <summary>
        ///     Name of primary key field
        /// </summary>
        private FieldInfo keyField;

        /// <summary>
        ///     Name of primary key property
        /// </summary>
        private PropertyInfo keyProperty;

        /// <summary>
        ///     Collection of column mapping attributes
        /// </summary>
        private Hashtable columnMap;

        /// <summary>
        ///     Collection of procedure mapping attributes
        /// </summary>
        private Dictionary<DBProcedureType, StoredProcedureMappingAttribute> procedureAttributes;

        /// <summary>
        ///     Collection stored procedure parameter mapping attributes
        /// </summary>
        private Hashtable parameterMap;

        #endregion Member Variables

        #region Properties

        /// <summary>
        ///     Gets or sets System.Collections.Hashtable that contais
        ///     table mapping details.
        /// </summary>
        public static Hashtable MappingTable
        {
            get { return mappingTable; }

            set { mappingTable = value; }
        }

        /// <summary>
        ///     Gets table name.
        /// </summary>
        public string TableName
        {
            get { return tableAttribute.TableName; }
        }

        /// <summary>
        ///     Gets view name
        /// </summary>
        public string ViewName
        {
            get { return tableAttribute.ViewName; }
        }

        /// <summary>
        ///     Gets primary key field
        /// </summary>
        public FieldInfo KeyField
        {
            get { return keyField; }
        }

        /// <summary>
        ///     Gets key property info.
        /// </summary>
        public PropertyInfo KeyProperty
        {
            get { return keyProperty; }
        }

        /// <summary>
        ///     Gets key column
        /// </summary>
        public string KeyColumn
        {
            get { return keyColumn; }
        }

        /// <summary>
        ///     Gets type of model
        /// </summary>
        public Type ModelType
        {
            get { return modelType; }
        }

        /// <summary>
        ///     Gets constructor info
        /// </summary>
        public ConstructorInfo Constructor
        {
            get { return constructor; }
        }

        /// <summary>
        ///     Gets collection of procedures
        /// </summary>
        public IDictionary Procedures
        {
            get { return procedureAttributes; }
        }

        /// <summary>
        ///     Gets collection of parameters
        /// </summary>
        public IDictionary Parameters
        {
            get { return parameterMap; }
        }

        /// <summary>
        ///     Gets a map of columns defined for the associated model type. The keys of this
        ///     map are the names of the model's properties. The values stored in this map are
        ///     ModelColumnMap instances.
        /// </summary>
        public IDictionary Columns
        {
            get { return columnMap; }
        }

        #endregion Properties

        #region Methods

        /// <summary>
        ///     Get data map of specified model type.
        /// </summary>
        /// <param name="modelType">
        ///     Type of model object.
        /// </param>
        /// <returns>
        ///     GlobalTranz.Framework.Common.Models.ModelDataMap object.
        /// </returns>
        public static ModelDataMap GetDataMap(Type modelType)
        {
            if (mappingTable == null)
                mappingTable = new Hashtable();

            var mapping = (ModelDataMap)mappingTable[modelType.FullName];
            if (mapping == null)
            {
                mapping = new ModelDataMap(modelType);
                mappingTable[modelType.FullName] = mapping;
            }

            return mapping;
        }

        /// <summary>
        ///     Set table attribute.
        /// </summary>
        private void SetTableAttribute()
        {
            object[] mappings;
            mappings = modelType.GetCustomAttributes(typeof(TableMappingAttribute), true);

            if ((mappings != null) && (mappings.Length > 0))
            {
                tableAttribute = (TableMappingAttribute)mappings[0];

                if (tableAttribute.KeyFieldName != null)
                    keyProperty = modelType.GetProperty(tableAttribute.KeyFieldName);

                if ((keyField != null) || (keyProperty != null))
                {
                    // Todo: uncomment when use filed mapping
                    // if (this.KeyField != null)
                    // {
                    //    mappings = this.keyField.GetCustomAttributes(typeof(ColumnMappingAttribute), true);
                    // }
                    // else if (this.keyProperty != null)
                    // {
                    //    mappings = this.keyProperty.GetCustomAttributes(typeof(ColumnMappingAttribute), true);
                    // }
                    mappings = keyProperty.GetCustomAttributes(typeof(ColumnMappingAttribute), true);

                    var attr = (ColumnMappingAttribute)mappings[0];
                    keyColumn = attr.ColumnName;
                }
                else
                {
                    keyColumn = tableAttribute.KeyFieldName;
                }
            }
        }

        /// <summary>
        ///     Create column mapping
        /// </summary>
        private void CreateColumnMapping()
        {
            columnMap = new Hashtable();

            // FieldInfo[] fields = modelType.GetFields(BindingFlags.IgnoreCase | BindingFlags.SuppressChangeType | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
            var properties = modelType.GetProperties();
            object[] mappings;
            ColumnMappingAttribute attr;

            if (properties.GetLength(0) > 0)
                foreach (var p in properties)
                {
                    mappings = p.GetCustomAttributes(typeof(ColumnMappingAttribute), true);

                    if ((mappings != null) && (mappings.Length > 0))
                    {
                        attr = (ColumnMappingAttribute)mappings[0];
                        var test = new ModelColumnMap(p, attr);
                        columnMap.Add(p.Name, new ModelColumnMap(p, attr));
                    }
                }
        }

        /// <summary>
        ///     Set procedure attribute.
        /// </summary>
        private void SetProcedureAttribute()
        {
            object[] mappings;
            procedureAttributes = new Dictionary<DBProcedureType, StoredProcedureMappingAttribute>();

            // Retrieves
            mappings = modelType.GetCustomAttributes(typeof(StoredProcedureMappingAttribute), true);

            if ((mappings != null) && (mappings.Length > 0))
                foreach (var map in mappings)
                {
                    var procedure = (StoredProcedureMappingAttribute)map;
                    procedureAttributes.Add(procedure.ProcedureType, procedure);
                }
        }

        /// <summary>
        ///     Create column mapping
        /// </summary>
        private void CreateParameterMapping()
        {
            parameterMap = new Hashtable();
            var properties = modelType.GetProperties();
            object[] mappings;
            StoredProcedureParameterMappingAttribute parameterAttribute;

            if (properties.GetLength(0) > 0)
                foreach (var property in properties)
                {
                    mappings = property.GetCustomAttributes(typeof(StoredProcedureParameterMappingAttribute), true);

                    if ((mappings != null) && (mappings.Length > 0))
                    {
                        var modelparamenteMap = new ArrayList();

                        foreach (var map in mappings)
                        {
                            parameterAttribute = (StoredProcedureParameterMappingAttribute)map;
                            modelparamenteMap.Add(new ModelParameterMap(property, parameterAttribute));
                        }

                        parameterMap.Add(property.Name, modelparamenteMap);
                    }
                }
        }

        #endregion Methods
    }
}