/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 TimeUtility
Purpose:                                      Change the Datetime format
==========================================================================================================*/
using System;
using System.Collections.Generic;
using System.Configuration;

namespace M4PL.Utilities
{
    public static class TimeUtility
    {
        public const char Seperator = ':';

        public const string Default = "00:00";

        public const string TimeStringMorningStart = "08:00";
        public const string TimeStringMorningEnd = "12:00";
        public const string TimeStringAfternoonStart = "13:00";
        public const string TimeStringAfternoonEnd = "17:00";

        public static DateTime DayLightSavingStartDate
        {
            get
            {
                return Convert.ToDateTime(ConfigurationManager.AppSettings["DayLightSavingStartDate"]);
            }
        }

        public static DateTime DayLightSavingEndDate
        {
            get
            {
                return Convert.ToDateTime(ConfigurationManager.AppSettings["DayLightSavingEndDate"]);
            }
        }

        public static bool IsDayLightSavingEnable
        {
            get
            {
                return (DateTime.Now.Date >= DayLightSavingStartDate && DateTime.Now.Date <= DayLightSavingEndDate) ? true : false;
            }
        }

        public static string GetTime(this DateTime date)
        {
            return date.ToString("HH:mm");
        }

        public static DateTime GetPacificDateTime()
        {
            return IsDayLightSavingEnable ? DateTime.UtcNow.AddHours(-7) : DateTime.UtcNow.AddHours(-8);
        }

        public static DateTime SetTime(this DateTime date, string timeString)
        {
            if (string.IsNullOrEmpty(timeString)) return date;
            if (timeString.Length != 5) return date;

            if (!char.IsDigit(timeString[0])) return date;
            if (!char.IsDigit(timeString[1])) return date;
            if (timeString[2] != Seperator) return date;
            if (!char.IsDigit(timeString[3])) return date;
            if (!char.IsDigit(timeString[4])) return date;

            var parts = timeString.Split(new[] { Seperator }, StringSplitOptions.RemoveEmptyEntries);

            return new DateTime(date.Year, date.Month, date.Day, Convert.ToInt32(parts[0]), Convert.ToInt32(parts[1]), 0);
        }

        public static DateTime SetToEndOfDay(this DateTime date)
        {
            return new DateTime(date.Year, date.Month, date.Day, 23, 59, 59);
        }

        public static List<string> BuildTimeList(TimeSpan? startTime = null)
        {
            if ((startTime != null) && (startTime.Value.Hours < 0))
                throw new Exception("startTime has an hours value less than zero");

            if ((startTime != null) && (startTime.Value.Minutes < 0))
                throw new Exception("startTime has a minutes value less than zero");

            var list = new List<string>();

            var startHour = startTime == null ? 0 : startTime.Value.Hours;
            var minutes = startTime == null ? 0 : startTime.Value.Minutes;

            var zeroPadding = startHour < 10 ? "0" : string.Empty;

            if (minutes < 15) list.Add(string.Format("{0}{1}:00", zeroPadding, startHour));
            if (minutes < 30) list.Add(string.Format("{0}{1}:15", zeroPadding, startHour));
            if (minutes < 45) list.Add(string.Format("{0}{1}:30", zeroPadding, startHour));
            if (minutes <= 59) list.Add(string.Format("{0}{1}:45", zeroPadding, startHour));

            for (var i = startHour + 1; i < 24; i++)
            {
                zeroPadding = i < 10 ? "0" : string.Empty;

                list.Add(string.Format("{0}{1}:00", zeroPadding, i));
                list.Add(string.Format("{0}{1}:15", zeroPadding, i));
                list.Add(string.Format("{0}{1}:30", zeroPadding, i));
                list.Add(string.Format("{0}{1}:45", zeroPadding, i));
            }

            return list;
        }

        public static List<string> BuildHourlyTimeList(TimeSpan? startTime = null)
        {
            if ((startTime != null) && (startTime.Value.Hours < 0))
                throw new Exception("startTime has an hours value less than zero");

            var list = new List<string>();

            for (var i = startTime == null ? 0 : startTime.Value.Hours; i < 24; i++)
            {
                var zeroPadding = i < 10 ? "0" : string.Empty;

                list.Add(string.Format("{0}{1}:00", zeroPadding, i));
            }

            return list;
        }

        public static bool IsValidTimeString(this string value)
        {
            return BuildTimeList().Contains(value);
        }

        public static bool IsValidFreeFormTimeString(this string value)
        {
            if (string.IsNullOrEmpty(value)) return false;
            if (value.Length != 5) return false;

            if (!char.IsDigit(value[0])) return false;
            if (!char.IsDigit(value[1])) return false;
            if (value[2] != Seperator) return false;
            if (!char.IsDigit(value[3])) return false;
            if (!char.IsDigit(value[4])) return false;

            if ((string.Format("{0}{1}", value[0], value[1]).ToInt() < 0) ||
                (string.Format("{0}{1}", value[0], value[1]).ToInt() > 23))
                return false;
            if ((string.Format("{0}{1}", value[3], value[4]).ToInt() < 0) ||
                (string.Format("{0}{1}", value[3], value[4]).ToInt() > 59))
                return false;
            return true;
        }

        public static string ConvertAmPm(this string time)
        {
            return !time.IsValidFreeFormTimeString() ? string.Empty : DateTime.Now.SetTime(time).ToString("hh:mm tt");
        }
    }
}