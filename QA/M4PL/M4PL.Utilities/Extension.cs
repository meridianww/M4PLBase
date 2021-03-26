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
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 Extension
// Purpose:                                      Contains objects related to Extension
//==========================================================================================================
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;

namespace M4PL.Utilities
{
    public static class Extension
    {
        public static int ToInt(this object value)
        {
            var x = default(int);
            return value == null
                ? x
                : value.GetType().IsEnum
                    ? (int)value
                    : int.TryParse(value.ToString(), out x) ? x : default(int);
        }

        public static long ToLong(this object value)
        {
            var x = default(long);
            return value == null ? x : long.TryParse(value.ToString(), out x) ? x : default(long);
        }

        public static Guid ToGuid(this object value)
        {
            var x = default(Guid);
            return value == null ? x : Guid.TryParse(value.ToString(), out x) ? x : default(Guid);
        }

        public static decimal ToDecimal(this object value)
        {
            var x = default(decimal);
            return value == null ? x : decimal.TryParse(value.ToString(), out x) ? x : default(decimal);
        }

        public static double ToDouble(this object value)
        {
            var x = default(double);
            return value == null ? x : double.TryParse(value.ToString(), out x) ? x : default(double);
        }

        public static bool ToBoolean(this object value)
        {
            bool x;
            if (value == null) return false;
            if (bool.TryParse(value.ToString(), out x)) return x;
            return false;
        }

        public static DateTime ToDateTime(this object value)
        {
            var x = DateUtility.SystemEarliestDateTime;
            return value == null
                ? x
                : DateTime.TryParse(value.ToString(), out x) ? x : DateUtility.SystemEarliestDateTime;
        }

        public static string GetString(this object value)
        {
            return value == null ? string.Empty : value.ToString();
        }

        public static bool EqualsOrdIgnoreCase(this string value, string compareTo)
        {
            value = value == null ? string.Empty : value;
            return value.Equals(compareTo, StringComparison.OrdinalIgnoreCase);
        }

        public static decimal Round(this decimal value)
        {
            return Math.Round(value, 4);
        }

        public static string StripTags(this string value)
        {
            return value.Replace("<", "&lt;").Replace(">", "&gt;");
        }

        public static string ReplaceTags(this string value)
        {
            return value.Replace("&lt;", "<").Replace("&gt;", ">");
        }

        public static string ReplaceNewLineWithHtmlBreak(this string value)
        {
            return value.Replace(Environment.NewLine, "<br />");
        }

        public static string ReplaceHtmlBreakWithNewLine(this string value)
        {
            return value.Replace("<br />", Environment.NewLine);
        }

        public static string StripTab(this string value)
        {
            return value.Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
        }

        public static string ReplaceTab(this string value)
        {
            return value.Replace("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", "\t");
        }

        public static Dictionary<int, string> GetAll<TEnum>(bool formatName = true) where TEnum : struct
        {
            var enumerationType = typeof(TEnum);

            if (!enumerationType.IsEnum)
                throw new ArgumentException("Enumeration type is expected.");

            var dictionary = new Dictionary<int, string>();

            foreach (int value in Enum.GetValues(enumerationType))
            {
                var name = formatName
                    ? Enum.GetName(enumerationType, value).FormattedString()
                    : Enum.GetName(enumerationType, value);
                dictionary.Add(value, name);
            }

            return dictionary;
        }

        public static bool EnumValueIsValid<TEnum>(this int value) where TEnum : struct
        {
            var enumerationType = typeof(TEnum);

            if (!enumerationType.IsEnum)
                throw new ArgumentException("Enumeration type is expected.");

            return Enum.GetValues(enumerationType).Cast<int>().Any(enumValue => value == enumValue);
        }

        public static T ToEnum<T>(this string value)
        {
            if (string.IsNullOrEmpty(value) || !Enum.IsDefined(typeof(T), value))
                return 0.ToEnum<T>();
            return (T)Enum.Parse(typeof(T), value, true);
        }

        public static T ToEnum<T>(this int value)
        {
            return (T)Enum.Parse(typeof(T), value.ToString());
        }

        public static List<string> EnumToArray<TEnum>() where TEnum : struct, IConvertible
        {
            var list = new List<string>();
            if (typeof(TEnum).IsEnum)
                foreach (TEnum oItem in Enum.GetValues(typeof(TEnum)))
                    list.Add(oItem.ToString());
            return list;
        }

        public static string SpaceJoin(this string[] values)
        {
            return string.Join(" ", values);
        }

        public static string[] SplitComma(this string value)
        {
            return (!string.IsNullOrWhiteSpace(value)) ? value.Split(',') : new string[] { };
        }

        public static string CommaJoin(this string[] values)
        {
            return string.Join(",", values);
        }

        public static string CommaJoin(this List<string> values)
        {
            return string.Join(",", values);
        }

        public static string TabJoin(this string[] values)
        {
            return string.Join("\t", values.Select(v => v.Replace("\t", " "))); // account for hidden tabs
        }

        public static string NewLineJoin(this string[] values)
        {
            return string.Join(Environment.NewLine, values.Select(v => v.Replace(Environment.NewLine, " ")));
            // account for hidden newlines
        }

        public static string WrapDoubleQuotes(this string value)
        {
            return string.Format("\"{0}\"", value);
        }

        public static string WrapSingleQuotes(this string value)
        {
            return string.Format("'{0}'", value);
        }

        public static double DegreeToRadian(this double angle)
        {
            return Math.PI * angle / 180.0;
        }

        public static double RadianToDegree(this double angle)
        {
            return angle * (180.0 / Math.PI);
        }

        public static char[] DataSeperators()
        {
            return new[] { '\t', ',', ';', ':', '|' };
        }

        public static char[] Seperators()
        {
            var chars = DataSeperators().ToList();
            chars.AddRange(Environment.NewLine.ToArray());
            return chars.ToArray();
        }

        public static string FormattedString(this object value)
        {
            return value == null
                ? string.Empty
                : Regex.Replace(value.ToString(), @"([a-z])([A-Z])", @"$1 $2", RegexOptions.None);
        }

        public static DateTime ToUniversalDateTime(this DateTime dateTime)
        {
            return TimeZone.CurrentTimeZone.ToUniversalTime(dateTime);
        }

        public static DateTime ToLocalDateTime(this DateTime utcDateTime)
        {
            return utcDateTime.ToLocalTime();
        }

        public static List<T> ConvertDataTableToModel<T>(DataTable dt)
        {
            List<T> data = new List<T>();
            foreach (DataRow row in dt.Rows)
            {
                T item = GetItem<T>(row);
                data.Add(item);
            }
            return data;
        }

        private static T GetItem<T>(DataRow dr)
        {
            Type temp = typeof(T);
            T obj = Activator.CreateInstance<T>();

            foreach (DataColumn column in dr.Table.Columns)
            {
                column.ColumnName = column.ColumnName.Replace(" ","");
                foreach (PropertyInfo pro in temp.GetProperties())
                {
                    if (pro.Name == column.ColumnName)
                        pro.SetValue(obj, dr[column.ColumnName], null);
                    else
                        continue;
                }
            }
            return obj;
        }
    }
}