using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization.Formatters.Binary;
using System.Xml;
using System.Xml.Serialization;

namespace M4PL.Utilities
{
    /// <summary>
    /// BaseConverter
    /// </summary>
    public static class BaseConverter
    {
        #region Public Method
        /// <summary>
        /// ConvertObjectToByteArray
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1720:IdentifiersShouldNotContainTypeNames", MessageId = "obj")]
        public static byte[] ConvertObjectToByteArray(Object obj)
        {
            if (obj == null)
                return null;
            BinaryFormatter bf = new BinaryFormatter();
            using (MemoryStream ms = new MemoryStream())
            {
                bf.Serialize(ms, obj);
                return ms.ToArray();
            }
        }

        /// <summary>
        /// RemoveColumnsFromDataTable
        /// </summary>
        /// <param name="dataTable"></param>
        /// <param name="columnNameList"></param>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1002:DoNotExposeGenericLists")]
        public static void RemoveColumnsFromDataTable(this DataTable dataTable, List<string> columnNameList)
        {
            if (columnNameList != null && columnNameList.Count > 0 && dataTable != null)
            {
                foreach (string columnName in columnNameList)
                {
                    if (dataTable.Columns.Contains(columnName))
                    {
                        dataTable.Columns.Remove(columnName);
                    }
                }
            }
        }

        /// <summary>
        /// ToDataTable
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="items"></param>
        /// <param name="usePropertyMappingName"></param>
        /// <returns></returns>
        public static DataTable ToDataTable<T>(this IList<T> items, bool usePropertyMappingName = false)
        {
            DataTable dataTable = null;

            if (items != null)
            {
                using (dataTable = new DataTable(typeof(T).Name))
                {
                    dataTable.Locale = System.Globalization.CultureInfo.InvariantCulture;

                    // Get all the properties.
                    PropertyInfo[] props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

                    foreach (PropertyInfo prop in props)
                    {
                        string columnName = prop.Name;

                        if (usePropertyMappingName)
                        {
                            var mappingAttribute = prop.GetCustomAttributes(typeof(PropertyMappingAttribute), true).FirstOrDefault() as PropertyMappingAttribute;

                            if (mappingAttribute != null && !string.IsNullOrEmpty(mappingAttribute.Name))
                            {
                                columnName = mappingAttribute.Name;
                            }
                        }

                        // Setting column names as Property names.
                        dataTable.Columns.Add(columnName);
                    }

                    foreach (T item in items)
                    {
                        var values = new object[props.Length];
                        for (int i = 0; i < props.Length; i++)
                        {
                            // Inserting property values to data table rows.
                            values[i] = props[i].GetValue(item, null);
                        }

                        dataTable.Rows.Add(values);
                    }
                }
            }

            return dataTable;
        }

        /// <summary>
        /// ToDataTableWithType
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="itemList"></param>
        /// <returns></returns>
        public static DataTable ToDataTableWithType<T>(IList<T> itemList)
        {
            DataTable dataTable = null;

            if (itemList != null)
            {
                using (dataTable = new DataTable(typeof(T).Name))
                {
                    // If the List is not associated with any model then the else portion needs to be executed.
                    if (itemList.Count > 0 && itemList[0].GetType().Namespace != "System.Dynamic")
                    {
                        dataTable.Locale = System.Globalization.CultureInfo.InvariantCulture;

                        // Get all the properties.
                        PropertyInfo[] props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

                        foreach (T item in itemList)
                        {
                            var values = new object[props.Length];

                            for (int i = 0; i < props.Length; i++)
                            {
                                // Inserting property values to data table rows.
                                values[i] = props[i].GetValue(item, null);
                            }

                            dataTable.Rows.Add(values);
                        }
                    }
                    else
                    {
                        // Add columns.
                        foreach (var property in (IDictionary<String, Object>)itemList[0])
                        {
                            dataTable.Columns.Add(property.Key, property.Value.GetType() == typeof(DBNull) ? typeof(object) : property.Value.GetType());
                        }

                        // Add rows.
                        foreach (object obj in itemList)
                        {
                            object[] array = new object[dataTable.Columns.Count];
                            int i = 0;

                            foreach (var property in (IDictionary<String, Object>)obj)
                            {
                                array[i] = property.Value;
                                i++;
                            }

                            dataTable.Rows.Add(array);
                        }
                    }
                }
            }

            return dataTable;
        }

        /// <summary>
        /// GetIdDataTable
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="itemList"></param>
        /// <returns></returns>
        public static DataTable GetIdDataTable<T>(IList<T> itemList)
        {
            DataTable dtIds = null;

            if (itemList != null)
            {
                using (dtIds = new DataTable(typeof(T).Name))
                {
                    //// will be passing these objects as a utt, so need to build a DataTable
                    dtIds.Columns.Add(new DataColumn("ID", typeof(int)));

                    foreach (object Id in itemList)
                    {
                        DataRow dr = dtIds.NewRow();
                        dr["ID"] = Id;
                        dtIds.Rows.Add(dr);
                    }
                }
            }
            return dtIds;
        }

        public static string GetXMLFromObject(object objectData)
        {
            StringWriter stringWriter = new StringWriter();
            XmlTextWriter textWriter = null;
            XmlSerializer serializer = new XmlSerializer(objectData.GetType());
            textWriter = new XmlTextWriter(stringWriter);
            serializer.Serialize(textWriter, objectData);
            stringWriter.Close();
            if (textWriter != null)
            {
                textWriter.Close();
            }

            return stringWriter.ToString();
        }

        #endregion Public Method
    }
}