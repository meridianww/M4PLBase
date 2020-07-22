#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace M4PL.Utilities
{
    /// <summary>
    ///     A class for encrypting and decrypting password.
    /// </summary>
    public class SecureString
    {
        /// <summary>
        ///     Secure key for encryption.
        /// </summary>
        private static readonly string securityKey = ConfigurationManager.AppSettings["SecureStringKey"] ??
                                                     "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

        /// <summary>
        ///     This method used for encrypting password
        /// </summary>
        /// <param name="stringToEncrypt">password string</param>
        /// <returns>encrypted password string</returns>
        public static string Encrypt(string stringToEncrypt)
        {
            if (stringToEncrypt.Trim() != string.Empty)
            {
                byte[] keyArray;
                var encryptArray = Encoding.UTF8.GetBytes(stringToEncrypt);

                // This class used for encrypt secure key
                var cryptoServiceProvideMD5 = new MD5CryptoServiceProvider();
                keyArray = cryptoServiceProvideMD5.ComputeHash(Encoding.UTF8.GetBytes(securityKey));
                cryptoServiceProvideMD5.Clear();

                var tripleDES = new TripleDESCryptoServiceProvider();
                tripleDES.Key = keyArray;
                tripleDES.Mode = CipherMode.ECB;
                tripleDES.Padding = PaddingMode.PKCS7;

                var cryToTransform = tripleDES.CreateEncryptor();
                var resultArray = cryToTransform.TransformFinalBlock(encryptArray, 0, encryptArray.Length);
                tripleDES.Clear();

                return Convert.ToBase64String(resultArray, 0, resultArray.Length);
            }
            return stringToEncrypt;
        }

        /// <summary>
        ///     This method used for decrypting password
        /// </summary>
        /// <param name="stringToDecrypt">encrypted password string</param>
        /// <returns>decrypted password string</returns>
        public static string Decrypt(string stringToDecrypt)
        {
            byte[] keyArray;
            stringToDecrypt = stringToDecrypt.Replace(" ", "+");
            var decryptArray = Convert.FromBase64String(stringToDecrypt);

            // This class used for encrypt secure key
            var cryptoServiceProvideMD5 = new MD5CryptoServiceProvider();
            keyArray = cryptoServiceProvideMD5.ComputeHash(Encoding.UTF8.GetBytes(securityKey));
            cryptoServiceProvideMD5.Clear();

            var tripleDES = new TripleDESCryptoServiceProvider();
            tripleDES.Key = keyArray;
            tripleDES.Mode = CipherMode.ECB;
            tripleDES.Padding = PaddingMode.PKCS7;

            var cryToTransform = tripleDES.CreateDecryptor();
            var resultArray = cryToTransform.TransformFinalBlock(decryptArray, 0, decryptArray.Length);
            tripleDES.Clear();

            return Encoding.UTF8.GetString(resultArray);
        }
    }
}