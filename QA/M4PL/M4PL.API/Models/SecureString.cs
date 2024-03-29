﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              13/10/2017
//Program Name:                                 SecureString
//Purpose:                                      Represents user's secure data
//====================================================================================================================================================*/

using System;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace M4PL.API.Models
{
	/// <summary>
	/// A class for encrypting and decrypting password.
	/// </summary>
	internal class SecureString
	{
		/// <summary>
		///     Secure key for encryption.
		/// </summary>
		private static string securityKey = ConfigurationManager.AppSettings["SecureStringKey"] ?? "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

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
				byte[] encryptArray = UTF8Encoding.UTF8.GetBytes(stringToEncrypt);

				// This class used for encrypt secure key
				MD5CryptoServiceProvider cryptoServiceProvideMD5 = new MD5CryptoServiceProvider();
				keyArray = cryptoServiceProvideMD5.ComputeHash(UTF8Encoding.UTF8.GetBytes(securityKey));
				cryptoServiceProvideMD5.Clear();

				TripleDESCryptoServiceProvider tripleDES = new TripleDESCryptoServiceProvider();
				tripleDES.Key = keyArray;
				tripleDES.Mode = CipherMode.ECB;
				tripleDES.Padding = PaddingMode.PKCS7;

				ICryptoTransform cryToTransform = tripleDES.CreateEncryptor();
				byte[] resultArray = cryToTransform.TransformFinalBlock(encryptArray, 0, encryptArray.Length);
				tripleDES.Clear();

				return Convert.ToBase64String(resultArray, 0, resultArray.Length);
			}
			else
			{
				return stringToEncrypt;
			}
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
			byte[] decryptArray = Convert.FromBase64String(stringToDecrypt);

			// This class used for encrypt secure key
			MD5CryptoServiceProvider cryptoServiceProvideMD5 = new MD5CryptoServiceProvider();
			keyArray = cryptoServiceProvideMD5.ComputeHash(UTF8Encoding.UTF8.GetBytes(securityKey));
			cryptoServiceProvideMD5.Clear();

			TripleDESCryptoServiceProvider tripleDES = new TripleDESCryptoServiceProvider();
			tripleDES.Key = keyArray;
			tripleDES.Mode = CipherMode.ECB;
			tripleDES.Padding = PaddingMode.PKCS7;

			ICryptoTransform cryToTransform = tripleDES.CreateDecryptor();
			byte[] resultArray = cryToTransform.TransformFinalBlock(decryptArray, 0, decryptArray.Length);
			tripleDES.Clear();

			return UTF8Encoding.UTF8.GetString(resultArray);
		}
	}
}