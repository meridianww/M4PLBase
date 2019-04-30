/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 DateUtility
Purpose:                                      Contains objects related to DateUtility
==========================================================================================================*/
using System;

namespace M4PL.Utilities
{
    public static class DateUtility
    {
        private const string Plus = "+";
        private const string MonthAddition = "m";

        public const string KeywordToday = "today";
        private static readonly char[] Seperators = { '+', '-' };

        public static DateTime SystemEarliestDateTime
        {
            get { return new DateTime(1753, 1, 1, 0, 0, 0); }
        }

        public static DateTime SystemLatestDateTime
        {
            get { return new DateTime(9999, 12, 31, 23, 59, 59); }
        }

        public static DateTime TimeToMinimum(this DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, 0, 0, 0);
        }

        public static DateTime TimeToMaximum(this DateTime dateTime)
        {
            return new DateTime(dateTime.Year, dateTime.Month, dateTime.Day, 23, 59, 59);
        }

        public static bool IsValidSystemDateTime(this DateTime value)
        {
            return (SystemEarliestDateTime <= value) && (value <= SystemLatestDateTime);
        }

        public static bool IsValidSystemDateTime(this string value)
        {
            if (string.IsNullOrEmpty(value)) return false;
            DateTime x;
            return DateTime.TryParse(value, out x) && x.IsValidSystemDateTime();
        }

        public static bool IsKeywordDate(this string value)
        {
            return value.Trim().ToLower().StartsWith(KeywordToday);
        }

        public static bool IsSystemEarliestDate(this DateTime value)
        {
            return value == SystemEarliestDateTime;
        }

        public static bool IsSystemLatestDate(this DateTime value)
        {
            return value == SystemLatestDateTime;
        }

        public static bool IsWeekend(this DateTime value)
        {
            return (value.DayOfWeek == DayOfWeek.Saturday) || (value.DayOfWeek == DayOfWeek.Sunday);
        }

        public static string BuildKeywordDateString(this string dateKeyword, string timeString)
        {
            if (!dateKeyword.IsKeywordDate()) return string.Empty;
            if (!timeString.IsValidFreeFormTimeString()) return string.Empty;

            return string.Format("{0}+{1}", dateKeyword, timeString);
        }

        public static string GetKeywordDatePortion(this string value)
        {
            // assumption: format is always today+#+00:00 or today-#+00:00 or today+00:00 where # is an int, 00:00 is time string
            if (!value.IsKeywordDate()) return string.Empty;
            var split = value.Split(Seperators, StringSplitOptions.RemoveEmptyEntries);

            if (split.Length == 1)
                return value;

            if (split.Length == 2)
                return split[1].IsValidFreeFormTimeString() ? split[0] : value;

            if (split.Length == 3)
            {
                var idx = value.LastIndexOf(Plus, StringComparison.Ordinal);
                return idx >= 0 ? value.Substring(0, idx) : value;
            }

            return string.Empty;
        }

        public static string GetKeywordTimePortion(this string value)
        {
            if (!value.IsKeywordDate()) return string.Empty;
            var datePortion = value.GetKeywordDatePortion();
            var replace = string.IsNullOrEmpty(datePortion) ? string.Empty : value.Replace(datePortion, string.Empty);
            return string.IsNullOrEmpty(replace) ? TimeUtility.Default : replace.Replace(Plus, string.Empty);
        }

        public static DateTime ParseKeywordDate(this string keyword)
        {
            if (!keyword.IsKeywordDate()) return SystemEarliestDateTime;

            var datePortion = keyword.GetKeywordDatePortion();
            var timePorttion = keyword.GetKeywordTimePortion().Trim();

            var split = datePortion.ToLower().Split(Seperators, StringSplitOptions.RemoveEmptyEntries);
            var date = split.Length > 1
                ? ParseDateAddition(split[1].Trim(), datePortion.Contains(Plus))
                : DateTime.Today;

            return !string.IsNullOrEmpty(timePorttion) && timePorttion.IsValidTimeString()
                ? date.SetTime(timePorttion)
                : date;
        }

        private static DateTime ParseDateAddition(this string dateDelta, bool addDelta)
        {
            if (dateDelta.ToLower().Contains(MonthAddition))
            {
                dateDelta = dateDelta.Replace(MonthAddition, string.Empty)
                    .Replace(MonthAddition.ToUpper(), string.Empty);
                int month;
                return !int.TryParse(dateDelta, out month)
                    ? DateTime.Today
                    : DateTime.Today.AddMonths(addDelta ? month : -1 * month);
            }

            int days;
            return !int.TryParse(dateDelta, out days)
                ? DateTime.Today
                : DateTime.Today.AddDays(addDelta ? days : -1 * days);
        }

        public static DateTime ParseDateAdditionForDate(this DateTime date, string dateDelta, bool addDelta)
        {
            if (dateDelta.ToLower().Contains(MonthAddition))
            {
                dateDelta = dateDelta.Replace(MonthAddition, string.Empty)
                    .Replace(MonthAddition.ToUpper(), string.Empty);
                int month;
                return !int.TryParse(dateDelta, out month)
                    ? date
                    : date.AddMonths(addDelta ? month : -1 * month);
            }

            int days;
            return !int.TryParse(dateDelta, out days)
                ? date
                : date.AddDays(addDelta ? days : -1 * days);
        }

        public static string FormattedShortDateSuppressEarliestDate(this object value)
        {
            var x = SystemEarliestDateTime;
            return
                (value == null ? x : DateTime.TryParse(value.ToString(), out x) ? x : SystemEarliestDateTime)
                    .FormattedShortDateSuppressEarliestDate();
        }

        public static string FormattedShortDateSuppressEarliestDate(this DateTime value)
        {
            return value == SystemEarliestDateTime ? string.Empty : value.FormattedShortDate();
        }

        public static string FormattedShortDateAltSuppressEarliestDate(this object value)
        {
            var x = SystemEarliestDateTime;
            return
                (value == null ? x : DateTime.TryParse(value.ToString(), out x) ? x : SystemEarliestDateTime)
                    .FormattedShortDateAltSuppressEarliestDate();
        }

        public static string FormattedShortDateAltSuppressEarliestDate(this DateTime value)
        {
            return value == SystemEarliestDateTime ? string.Empty : value.FormattedShortDateAlt();
        }

        public static string FormattedLongDateAltSuppressEarliestDate(this object value)
        {
            var x = SystemEarliestDateTime;
            return
                (value == null ? x : DateTime.TryParse(value.ToString(), out x) ? x : SystemEarliestDateTime)
                    .FormattedLongDateAltSuppressEarliestDate();
        }

        public static string FormattedLongDateAltSuppressEarliestDate(this DateTime value)
        {
            return value == SystemEarliestDateTime ? string.Empty : value.FormattedLongDateAlt();
        }

        public static string FormattedLongDateSuppressEarliestDate(this object value)
        {
            var x = SystemEarliestDateTime;
            return
                (value == null ? x : DateTime.TryParse(value.ToString(), out x) ? x : SystemEarliestDateTime)
                    .FormattedLongDateSuppressEarliestDate();
        }

        public static string FormattedLongDateSuppressEarliestDate(this DateTime value)
        {
            return value == SystemEarliestDateTime ? string.Empty : value.FormattedLongDate();
        }

        public static string FormattedSuppressMidnightDate(this DateTime value)
        {
            return (value.Hour == 0) && (value.Minute == 0) && (value.Second == 0)
                ? value.FormattedShortDate()
                : value.FormattedLongDate();
        }

        public static string FormattedShortDate(this object value)
        {
            var x = SystemEarliestDateTime;
            return
                (value == null ? x : DateTime.TryParse(value.ToString(), out x) ? x : SystemEarliestDateTime)
                    .FormattedShortDate();
        }

        public static string FormattedShortDate(this DateTime date)
        {
            return string.Format("{0:MM/dd/yyyy}", date);
        }

        public static string FormattedShortDateAlt(this object value)
        {
            var x = SystemEarliestDateTime;
            return
                (value == null ? x : DateTime.TryParse(value.ToString(), out x) ? x : SystemEarliestDateTime)
                    .FormattedLongDateAlt();
        }

        public static string FormattedShortDateAlt(this DateTime date)
        {
            return string.Format("{0:yyyy-MM-dd}", date);
        }

        public static string FormattedLongDate(this object value)
        {
            var x = SystemEarliestDateTime;
            return
                (value == null ? x : DateTime.TryParse(value.ToString(), out x) ? x : SystemEarliestDateTime)
                    .FormattedLongDate();
        }

        public static string FormattedLongDate(this DateTime date)
        {
            return string.Format("{0:MM/dd/yyyy HH:mm:ss}", date);
        }

        public static string FormattedLongDateAlt(this object value)
        {
            var x = SystemEarliestDateTime;
            return
                (value == null ? x : DateTime.TryParse(value.ToString(), out x) ? x : SystemEarliestDateTime)
                    .FormattedLongDateAlt();
        }

        public static string FormattedLongDateAlt(this DateTime date)
        {
            return string.Format("{0:yyyy-MM-dd HH:mm:ss}", date);
        }

        public static string FormattedTimeOfDay(this DateTime date)
        {
            return string.Format("{0:HH:mm}", date);
        }

        public static string FormattedEasternTimeDate(this DateTime dateTime)
        {
            return string.Format("{0:yyyy-MM-dd}T{0:HH:mm}-05:00", dateTime);
        }
    }
}