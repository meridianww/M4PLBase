using System;

namespace M4PL.Web.Tests.Utilities
{
    public class RandomGenerator
    {
        protected Random randomNumbers = new System.Random();

        /// <summary>
        /// Return a base 36 representation of a number. This is done because base 36 is
        /// all 26 letters plus all 10 digits, so it can pack large numbers into short printable strings.
        /// </summary>
        /// <param name="Value"></param>
        /// <returns></returns>
        public static string ToBase36(long Value)
        {
            char[] BASE36_CHARS = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };
            return LongToString(Value, BASE36_CHARS);
        }

        /// <summary>
        /// Source: http://stackoverflow.com/questions/923771/quickest-way-to-convert-a-base-10-number-to-any-base-in-net.
        /// </summary>
        /// <param name="value">The number to represent</param>
        /// <param name="baseChars">All character values in the base (e.g. {'0','1'} for base 2)</param>
        /// <returns></returns>
        private static string LongToString(long value, char[] baseChars)
        {
            string result = string.Empty;
            int targetBase = baseChars.Length;
            do
            {
                result = baseChars[value % targetBase] + result;
                value = value / targetBase;
            }
            while (value > 0);
            return result;
        }

        public string GenerateRandomString()
        {
            return ToBase36(this.randomNumbers.Next(1, int.MaxValue));
        }

        public string AppendRandomStringTo(String prefix)
        {
            return String.Format("{0}{1}", prefix, GenerateRandomString());
        }

        public string GenerateEmailForDomain(String domain)
        {
            return String.Format("{0}@{1}", GenerateRandomString(), domain);
        }

        public string GenerateRandomTenDigit()
        {
            long tenDigitNumber = this.randomNumbers.Next(9999999, int.MaxValue);
            return "9" + tenDigitNumber;

        }

        public int GenerateRandomTwoDigitNumber()
        {
            return (this.randomNumbers.Next(10, 99));
        }
    }
}
