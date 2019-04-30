//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Deepika
//Date Programmed:                              26/5/2016
//Program Name:                                 DataReaderConverter
//Purpose:                                      Deserializes DataTable and emits JSON
//====================================================================================================================================================

using M4PL.DataAccess.SQLSerializer.AttributeMapping;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Reflection;

namespace M4PL.DataAccess.SQLSerializer.Factory.Converters
{
    /// <summary>
    ///     This class converts data reader object to corresponding model or array of models.
    /// </summary>
    public struct DataReaderConverter
    {
        #region Member Variables

        /// <summary>
        ///     Details of model mappers
        /// </summary>
        private readonly ModelDataMap mapping;

        #endregion Member Variables

        #region Constructors

        /// <summary>
        ///     Constructor of DataReaderConverter class. It accepts model type.
        /// </summary>
        /// <param name="modelType">
        ///     The type of model to be associated with the new instance of DataReaderConverter
        /// </param>
        public DataReaderConverter(Type modelType)
        {
            mapping = ModelDataMap.GetDataMap(modelType);
        }

        /// <summary>
        ///     Constructor of DataReaderConverter class. It accepts object of ModelDataMap class.
        /// </summary>
        /// <param name="mapping">
        ///     Object of ModelDataMap class.
        /// </param>
        public DataReaderConverter(ModelDataMap mapping)
        {
            this.mapping = mapping;
        }

        #endregion Constructors

        #region Member Methods

        /// <summary>
        ///     This method is used to read a set of rows from a datareader and convert them into an
        ///     array of the model.
        /// </summary>
        /// <param name="dataReader">
        ///     The dataReader that will be used to construct the models
        /// </param>
        /// <returns>
        ///     An array of model instances
        /// </returns>
        public IModel[] ConvertDatReaderToModels(IDataReader dataReader)
        {
            var modelList = new ArrayList();
            IModel[] models = null;

            // open the data reader
            while (dataReader.Read())
            {
                // convert data reader to a model
                var model = ConvertDataReaderToModel(dataReader);
                modelList.Add(model);
            }

            // convert array list to model array
            models = (IModel[])modelList.ToArray(mapping.ModelType);
            return models;
        }

        /// <summary>
        ///     This method is used to read a set of rows from a data reader and convert them into an
        ///     array of the model.
        /// </summary>
        /// <typeparam name="T">
        ///     Any object that implements Imodel interface
        /// </typeparam>
        /// <param name="dataReader">
        ///     The dataReader that will be used to construct the models
        /// </param>
        /// <returns>
        ///     A collection of model instances
        /// </returns>
        public List<T> ConvertDataReaderToModels<T>(IDataReader dataReader) where T : IModel
        {
            List<T> models = null;

            if ((dataReader != null) && !dataReader.IsClosed)
            {
                models = new List<T>();

                // open the data reader
                while (dataReader.Read())
                {
                    // convert data reader to a model
                    var model = ConvertDataReaderToModel(dataReader);
                    models.Add((T)model);
                }
            }

            return models;
        }

        /// <summary>
        ///     This method is used to read the current row from a datareader and convert it into an
        ///     instance of the model.
        ///     This method assumes dataReader.Read() has already been called
        ///     and the reader is advanced to the correct row to read.
        /// </summary>
        /// <param name="dataReader">
        ///     The dataReader that will be used to construct the model
        /// </param>
        /// <returns>
        ///     An instance of the model
        /// </returns>
        public IModel ConvertDataReaderToModel(IDataReader dataReader)
        {
            IModel model = null;
            model = (IModel)mapping.Constructor.Invoke(null);

            // Create the model here
            if (dataReader != null)
            {
                object val;
                foreach (ModelColumnMap column in mapping.Columns.Values)
                {
                    try
                    {
                        val = dataReader[column.ColumnName];
                    }
                    catch (IndexOutOfRangeException)
                    {
                        val = null;
                    }

                    // set the value for model property
                    if (column.Field != null)
                        SetFieldValue(model, column, val);
                    else
                        SetFieldValue(model, column.Property, val);
                }
            }

            return model;
        }

        /// <summary>
        ///     This method is used to set the property of the model field.
        /// </summary>
        /// <param name="model">
        ///     Model whose property to be set.
        /// </param>
        /// <param name="field">
        ///     Property to be set.
        /// </param>
        /// <param name="val">
        ///     Value of the property
        /// </param>
        public void SetFieldValue(object model, FieldInfo field, object val)
        {
            var column = (ModelColumnMap)mapping.Columns[field.Name];
            SetFieldValue(model, column, val);
        }

        /// <summary>
        ///     This method is used to set the property of the model using ModelColumnMap class.
        /// </summary>
        /// <param name="model">
        ///     Model whose property to be set.
        /// </param>
        /// <param name="column">
        ///     Object of ModelColumnMap class
        /// </param>
        /// <param name="val">
        ///     Value to be set.
        /// </param>
        public void SetFieldValue(object model, ModelColumnMap column, object val)
        {
            // set value to null if it is null or DBNull
            if ((val == null) || (val == DBNull.Value))
            {
                val = null;
            }
            else if (column.Field.FieldType.IsEnum)
            {
                val = Enum.ToObject(column.FieldType, val);
            }
            else
            {
                // get the value from the field
                var valType = val.GetType();
                if (valType != column.FieldType)
                {
                    var typeArray = new Type[1];
                    var valueArray = new object[1];
                    typeArray[0] = valType;
                    ConstructorInfo ci;
                    ci = column.FieldType.GetConstructor(typeArray);
                    if (ci != null)
                    {
                        valueArray[0] = val;
                        val = ci.Invoke(valueArray);
                    }
                    else
                    {
                        try
                        {
                            val = Convert.ChangeType(val, column.FieldType);
                        }
                        catch (Exception ex)
                        {
                            var message = ex.Message;
                        }
                    }
                }
            }

            // set the value to the model's field
            column.Field.SetValue(model, val);
        }

        /// <summary>
        ///     This method is used to set the property of the model using ModelColumnMap class.
        /// </summary>
        /// <param name="model">
        ///     Model whose property to be set.
        /// </param>
        /// <param name="property">
        ///     Object of ModelColumnMap class
        /// </param>
        /// <param name="val">
        ///     Value to be set.
        /// </param>
        public void SetFieldValue(object model, PropertyInfo property, object val)
        {
            // set value to null if it is null or DBNull
            if ((val == null) || (val == DBNull.Value))
            {
                val = null;
            }
            else if (property.PropertyType.IsEnum)
            {
                val = Enum.ToObject(property.PropertyType, val);
            }
            else
            {
                // get the value from the field
                var valType = val.GetType();
                if (valType != property.PropertyType)
                {
                    var typeArray = new Type[1];
                    var valueArray = new object[1];
                    typeArray[0] = valType;
                    ConstructorInfo ci;
                    ci = property.PropertyType.GetConstructor(typeArray);
                    if (ci != null)
                    {
                        valueArray[0] = val;
                        val = ci.Invoke(valueArray);
                    }
                    else
                    {
                        val = Convert.ChangeType(val, property.PropertyType);
                    }
                }
            }

            // set the value to the model's field
            property.SetValue(model, val, null);
        }

        #endregion Member Methods
    }
}