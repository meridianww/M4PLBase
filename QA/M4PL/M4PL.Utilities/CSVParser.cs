/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              02/04/2020
Program Name:                                 CSVParser
Purpose:                                      Utility Class For CSV Parser
==========================================================================================================*/

using System.Collections;
using System.Data;
using System.IO;
using System.Text;

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
                dtUploadedOrders = CSVParser.Parse(stream.ReadToEnd(), true);
                dtUploadedOrders.Locale = System.Globalization.CultureInfo.InvariantCulture;
            }

            return dtUploadedOrders;
        }

        public static DataTable Parse(string data, bool headers)
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
