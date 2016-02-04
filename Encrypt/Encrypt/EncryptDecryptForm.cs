using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Encrypt
{
    public partial class EncryptDecryptForm : Form
    {
        public EncryptDecryptForm()
        {
            InitializeComponent();
        }
        private static string securityKey = "XcblWebServiceMERIDNow";

        /// <summary>
        ///     This method used for encrypting password 
        /// </summary>
        /// <param name="stringToEncrypt">string - password </param>
        /// <returns>string - encrypted password</returns>
        public static string Encrypt(string stringToEncrypt, string securekey)
        {
            try
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
            catch
            {
                return "Error: Securitykey does not match";
            }

        }

        /// <summary>
        ///     This method used for decrypting password     
        /// </summary>
        /// <param name="stringToDecrypt">string - encrypted password</param>
        /// <returns>string - decrypted password</returns>
        public static string Decrypt(string stringToDecrypt, string securekey)
        {
            try
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
            catch
            {
                return "Error: Securitykey does not match";
            }
        }

        public void button1_Click(object sender, EventArgs e)
        {
            string userName = txtUserName.Text;
            string password = txtPassword.Text;
            string hashkey = txtHaskkey.Text;

            if (string.IsNullOrWhiteSpace(userName) || string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(hashkey))
            {
                lblErrorMessage.Text = String.Format("{0} is required.", string.IsNullOrWhiteSpace(userName) ? "Username" : (string.IsNullOrWhiteSpace(password) ? "Password" : "HashKey"));
                lblErrorMessage.Visible = true;
                return;
            }

            lblErrorMessage.Text = string.Empty;
            lblErrorMessage.Visible = false;

            UserEncrypt.Text = Encrypt(userName, hashkey);
            txtUserName.Text = UserEncrypt.Text;
         
            PwdEncrypt.Text = Encrypt(password, hashkey);
            txtPassword.Text = PwdEncrypt.Text;

            lblUserEncryptMessage.Text = "Encrypt User";
            lblPwdEncryptMessage.Text = "Encrypt Pwd";
            UserEncrypt.Visible = true;
            lblUserEncryptMessage.Visible = true;
            lblPwdEncryptMessage.Visible = true;
            PwdEncrypt.Visible = true;
        }

        public void button2_Click(object sender, EventArgs e)
        {
            string userName = txtUserName.Text;
            string password = txtPassword.Text;
            string hashkey = txtHaskkey.Text;

            if (string.IsNullOrWhiteSpace(userName) || string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(hashkey))
            {
                lblErrorMessage.Text = String.Format("{0} is required.", string.IsNullOrWhiteSpace(userName) ? "Username" : (string.IsNullOrWhiteSpace(password) ? "Password" : "HashKey"));
                lblErrorMessage.Visible = true;
                return;
            }

            lblErrorMessage.Text = string.Empty;
            lblErrorMessage.Visible = false;

            UserEncrypt.Text = Decrypt(userName, txtHaskkey.Text);
            PwdEncrypt.Text = Decrypt(password, txtHaskkey.Text);
            txtUserName.Text = UserEncrypt.Text;
            txtPassword.Text = PwdEncrypt.Text;

            lblUserEncryptMessage.Text = "Decrypt User";
            lblPwdEncryptMessage.Text = "Decrypt Pwd";

            UserEncrypt.Visible = true;
            lblUserEncryptMessage.Visible = true;
            lblPwdEncryptMessage.Visible = true;
            PwdEncrypt.Visible = true;
        }

        public void btnClear_Click(object sender, EventArgs e)
        {
            txtUserName.Text = "";
            txtPassword.Text = "";
            txtHaskkey.Text = "";
            UserEncrypt.Text = "";
            PwdEncrypt.Text = "";

            lblUserEncryptMessage.Visible = false;
            lblPwdEncryptMessage.Visible = false; 
        }
    }
}
