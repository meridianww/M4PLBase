using System;

namespace M4PL.Utilities
{
    public static class UtilityExtensions
    {
        public static decimal ToDecimal(this string value)
        {
            decimal returnValue;

            return decimal.TryParse(value, out returnValue) ? returnValue : 0m;
        }

        public static byte ToByte(this string value)
        {
            byte returnValue;

            return byte.TryParse(value, out returnValue) ? returnValue : (byte)0;
        }

        public static int ToInt(this string value)
        {
            int returnValue;

            return int.TryParse(value, out returnValue) ? returnValue : 0;
        }

        public static long ToLong(this string value)
        {
            long returnValue;

            return long.TryParse(value, out returnValue) ? returnValue : 0;
        }

        public static int ToShort(this string value)
        {
            short returnValue;

            return short.TryParse(value, out returnValue) ? returnValue : 0;
        }

        public static DateTime? ToDate(this string dateValue)
        {
            DateTime value;

            if (DateTime.TryParse(dateValue, out value))
            {
                return value;
            }

            return null;
        }

        public static DateTime ToDateTime(this string dateValue)
        {
            DateTime value;
            DateTime.TryParse(dateValue, out value);

            return value;
        }
    }
}
