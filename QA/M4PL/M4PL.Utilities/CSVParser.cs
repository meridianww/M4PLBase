#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              02/04/2020
// Program Name:                                 CSVParser
// Purpose:                                      Utility Class For CSV Parser
//==========================================================================================================

using System;
using System.Collections;
using System.Data;
using System.IO;
using System.Text;
using System.Linq;

namespace M4PL.Utilities
{
    public static class CSVParser
    {
        public static DataTable GetDataTableForCSVByteArray(byte[] fileContent)
        {
            DataTable dtUploadedOrders = null;
            using (MemoryStream msUplodedfile = new MemoryStream(fileContent))
            {
                StreamReader stream = new StreamReader(msUplodedfile);
                dtUploadedOrders = CSVParser.Parse(stream.ReadToEnd(), true, false);
                dtUploadedOrders.Locale = System.Globalization.CultureInfo.InvariantCulture;
            }

            return dtUploadedOrders;
        }
        
        public static DataTable Parse(string data, bool headers, bool isDriverScrubReport)
        {
            using (StringReader strData = new StringReader(data))
                return Parse(strData, headers);
        }

        public static DataTable Parse(string data)
        {
            using (StringReader strData = new StringReader(data))
                return Parse(data);
        }

        public static DataTable Parse(TextReader stream)
        {
            return Parse(stream, false);
        }

        public static DataTable Parse(TextReader stream, bool headers)
        {
            DataTable table = new DataTable();
            using (table)
            {
                table.Locale = System.Globalization.CultureInfo.InvariantCulture;

                CsvStream csv = new CsvStream(stream);
                string[] row = csv.GetNextRow();
                if (row == null)
                    return null;
                if (headers)
                {
                    foreach (string header in row)
                    {
                        if (header != null && header.Length > 0 && !table.Columns.Contains(header))
                            table.Columns.Add(header, typeof(string));
                        else
                            table.Columns.Add(GetNextColumnHeader(table), typeof(string));
                    }

                    row = csv.GetNextRow();
                }

                while (row != null)
                {
                    while (row.Length > table.Columns.Count)
                        table.Columns.Add(GetNextColumnHeader(table), typeof(string));
                    table.Rows.Add(row);
                    row = csv.GetNextRow();
                }
            }

            return table;
        }

        private static string GetNextColumnHeader(DataTable table)
        {
            int c = 1;
            while (true)
            {
                string h = "Column" + c++;
                if (!table.Columns.Contains(h))
                    return h;
            }
        }

        public static string _DatatableColumns = "QMS ShippedOn,QMAPSDisposition,QMSStatusDescription,4P,3P,Original ControlID,QMS ControlID,QRC Grouping,QRC Description,ProductCategory,ProductSubCategory,ProductSubCategory2,ModelName,CustomerBusinessType,ChannelCD,NationalAccountName,CustomerName,Ship From Location,QMS Remarks,Days Between,Original Delivered to QMS Accepted,Sum of QMSUnits,Sum of QMSDollars";
        public static DataTable GetDataTableForCSVByteArrayDriverScrubReport(byte[] fileContent, out string filterDescription, out DateTime startDate, out DateTime endDate)
        {
            DataTable dtUploadedOrders = null;
            using (MemoryStream msUplodedfile = new MemoryStream(fileContent))
            {
                StreamReader stream = new StreamReader(msUplodedfile);
                dtUploadedOrders = CSVParser.ParseDriverScrubReport(stream.ReadToEnd(), true, out filterDescription, out startDate, out endDate);
                dtUploadedOrders.Locale = System.Globalization.CultureInfo.InvariantCulture;
            }

            return dtUploadedOrders;
        }

        public static DataTable ParseDriverScrubReport(string data, bool headers, out string filterDescription, out DateTime startDate, out DateTime endDate)
        {
            using (StringReader strData = new StringReader(data))
                return ParseDriverScrubReport(strData, headers, out filterDescription, out startDate, out endDate);
        }

        public static DataTable ParseDriverScrubReport(TextReader stream, bool headers, out string filterDescription, out DateTime startDate, out DateTime endDate)
        {
            DataTable table = new DataTable();
            try
            {
                using (table)
                {
                    table.Locale = System.Globalization.CultureInfo.InvariantCulture;

                    CsvStream csv = new CsvStream(stream);
                    filterDescription = csv.GetNextRow()[0];
                    string[] dates = csv.GetNextRow();
                    startDate = DateTime.Parse(dates[0]);
                    endDate = DateTime.Parse(dates[1]);
                    string[] row = csv.GetNextRow();
                    if (row == null)
                        return null;
                    if (headers)
                    {
                        foreach (string header in row)
                        {
                            if (header != null && header.Length > 0 && !table.Columns.Contains(header))
                                table.Columns.Add(header, typeof(string));
                            else
                                table.Columns.Add(GetNextColumnHeader(table), typeof(string));
                        }

                        row = csv.GetNextRow();
                    }

                    while (row != null)
                    {
                        while (row.Length > table.Columns.Count)
                            table.Columns.Add(GetNextColumnHeader(table), typeof(string));
                        table.Rows.Add(row);
                        row = csv.GetNextRow();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Incorrect format of CSV, Error: " + ex.Message);
            }

            return table;
        }

        private class CsvStream
        {
            private TextReader stream;

            private bool eOS = false;

            private bool eOL = false;

            private char[] buffer = new char[4096];

            private int pos = 0;

            private int length = 0;
            public CsvStream(TextReader s)
            {
                stream = s;
            }

            public string[] GetNextRow()
            {
                ArrayList row = new ArrayList();
                while (true)
                {
                    string item = GetNextItem();
                    if (item == null)
                        return row.Count == 0 ? null : (string[])row.ToArray(typeof(string));
                    row.Add(item);
                }
            }

            public string GetDriverScrubReportFilter()
            {
                while (true)
                {
                    return GetNextItem();
                }
            }

            public string[] GetDriverScrubReportDates()
            {
                ArrayList row = new ArrayList();
                int count = 0;
                while (true)
                {
                    string item = GetNextItem();
                    if (item == null || count > 1)
                        return row.Count == 0 ? null : (string[])row.ToArray(typeof(string));
                    row.Add(item);

                    count++;
                }
            }

            private string GetNextItem()
            {
                if (eOL)
                {
                    eOL = false;
                    return null;
                }

                bool quoted = false;
                bool predata = true;
                bool postdata = false;
                StringBuilder item = new StringBuilder();

                while (true)
                {
                    char c = GetNextChar(true);
                    if (eOS)
                        return item.Length > 0 ? item.ToString() : null;

                    if ((postdata || !quoted) && c == ',')
                        return item.ToString();

                    if ((predata || postdata || !quoted) && (c == '\x0A' || c == '\x0D'))
                    {
                        eOL = true;
                        if (c == '\x0D' && GetNextChar(false) == '\x0A')
                            GetNextChar(true);
                        return item.ToString();
                    }

                    if (predata && c == ' ')
                        continue;

                    if (predata && c == '"')
                    {
                        quoted = true;
                        predata = false;
                        continue;
                    }

                    if (predata)
                    {
                        predata = false;
                        item.Append(c);
                        continue;
                    }

                    if (c == '"' && quoted)
                    {
                        if (GetNextChar(false) == '"')
                            item.Append(GetNextChar(true));
                        else
                            postdata = true;
                        continue;
                    }

                    item.Append(c);
                }
            }

            private char GetNextChar(bool eat)
            {
                if (pos >= length)
                {
                    length = stream.ReadBlock(buffer, 0, buffer.Length);
                    if (length == 0)
                    {
                        eOS = true;
                        return '\0';
                    }

                    pos = 0;
                }

                if (eat)
                    return buffer[pos++];
                else
                    return buffer[pos];
            }
        }
    }
}
