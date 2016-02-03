namespace Encrypt
{
    partial class EncryptDecryptForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.txtUserName = new System.Windows.Forms.TextBox();
            this.txtPassword = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.btnEncrypt = new System.Windows.Forms.Button();
            this.btnDecrypt = new System.Windows.Forms.Button();
            this.UserEncrypt = new System.Windows.Forms.Label();
            this.txtHaskkey = new System.Windows.Forms.TextBox();
            this.lblHashKey = new System.Windows.Forms.Label();
            this.PwdEncrypt = new System.Windows.Forms.Label();
            this.lblUserEncryptMessage = new System.Windows.Forms.Label();
            this.lblPwdEncryptMessage = new System.Windows.Forms.Label();
            this.lblErrorMessage = new System.Windows.Forms.Label();
            this.btnClear = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // txtUserName
            // 
            this.txtUserName.Location = new System.Drawing.Point(165, 40);
            this.txtUserName.Name = "txtUserName";
            this.txtUserName.Size = new System.Drawing.Size(138, 20);
            this.txtUserName.TabIndex = 0;
            // 
            // txtPassword
            // 
            this.txtPassword.Location = new System.Drawing.Point(165, 63);
            this.txtPassword.Name = "txtPassword";
            this.txtPassword.Size = new System.Drawing.Size(138, 20);
            this.txtPassword.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(43, 43);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(55, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Username";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(43, 70);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 13);
            this.label2.TabIndex = 3;
            this.label2.Text = "Password";
            // 
            // btnEncrypt
            // 
            this.btnEncrypt.Location = new System.Drawing.Point(165, 114);
            this.btnEncrypt.Name = "btnEncrypt";
            this.btnEncrypt.Size = new System.Drawing.Size(64, 23);
            this.btnEncrypt.TabIndex = 4;
            this.btnEncrypt.Text = "Encrypt";
            this.btnEncrypt.UseVisualStyleBackColor = true;
            this.btnEncrypt.Click += new System.EventHandler(this.button1_Click);
            // 
            // btnDecrypt
            // 
            this.btnDecrypt.Location = new System.Drawing.Point(235, 114);
            this.btnDecrypt.Name = "btnDecrypt";
            this.btnDecrypt.Size = new System.Drawing.Size(68, 23);
            this.btnDecrypt.TabIndex = 5;
            this.btnDecrypt.Text = "Decrypt";
            this.btnDecrypt.UseVisualStyleBackColor = true;
            this.btnDecrypt.Click += new System.EventHandler(this.button2_Click);
            // 
            // UserEncrypt
            // 
            this.UserEncrypt.AutoSize = true;
            this.UserEncrypt.Location = new System.Drawing.Point(169, 181);
            this.UserEncrypt.Name = "UserEncrypt";
            this.UserEncrypt.Size = new System.Drawing.Size(0, 13);
            this.UserEncrypt.TabIndex = 6;
            this.UserEncrypt.Visible = false;
            // 
            // txtHaskkey
            // 
            this.txtHaskkey.Location = new System.Drawing.Point(165, 88);
            this.txtHaskkey.Name = "txtHaskkey";
            this.txtHaskkey.Size = new System.Drawing.Size(138, 20);
            this.txtHaskkey.TabIndex = 7;
            // 
            // lblHashKey
            // 
            this.lblHashKey.AutoSize = true;
            this.lblHashKey.Location = new System.Drawing.Point(43, 95);
            this.lblHashKey.Name = "lblHashKey";
            this.lblHashKey.Size = new System.Drawing.Size(50, 13);
            this.lblHashKey.TabIndex = 8;
            this.lblHashKey.Text = "HashKey";
            // 
            // PwdEncrypt
            // 
            this.PwdEncrypt.AutoSize = true;
            this.PwdEncrypt.Location = new System.Drawing.Point(169, 203);
            this.PwdEncrypt.Name = "PwdEncrypt";
            this.PwdEncrypt.Size = new System.Drawing.Size(0, 13);
            this.PwdEncrypt.TabIndex = 9;
            this.PwdEncrypt.Visible = false;
            // 
            // lblUserEncryptMessage
            // 
            this.lblUserEncryptMessage.AutoSize = true;
            this.lblUserEncryptMessage.Location = new System.Drawing.Point(49, 181);
            this.lblUserEncryptMessage.Name = "lblUserEncryptMessage";
            this.lblUserEncryptMessage.Size = new System.Drawing.Size(80, 13);
            this.lblUserEncryptMessage.TabIndex = 10;
            this.lblUserEncryptMessage.Text = "Encrypted User";
            this.lblUserEncryptMessage.Visible = false;
            // 
            // lblPwdEncryptMessage
            // 
            this.lblPwdEncryptMessage.AutoSize = true;
            this.lblPwdEncryptMessage.Location = new System.Drawing.Point(49, 203);
            this.lblPwdEncryptMessage.Name = "lblPwdEncryptMessage";
            this.lblPwdEncryptMessage.Size = new System.Drawing.Size(103, 13);
            this.lblPwdEncryptMessage.TabIndex = 11;
            this.lblPwdEncryptMessage.Text = "Encrypted password";
            this.lblPwdEncryptMessage.Visible = false;
            // 
            // lblErrorMessage
            // 
            this.lblErrorMessage.AutoSize = true;
            this.lblErrorMessage.Location = new System.Drawing.Point(62, 231);
            this.lblErrorMessage.Name = "lblErrorMessage";
            this.lblErrorMessage.Size = new System.Drawing.Size(0, 13);
            this.lblErrorMessage.TabIndex = 12;
            // 
            // btnClear
            // 
            this.btnClear.Location = new System.Drawing.Point(194, 143);
            this.btnClear.Name = "btnClear";
            this.btnClear.Size = new System.Drawing.Size(75, 23);
            this.btnClear.TabIndex = 13;
            this.btnClear.Text = "Clear";
            this.btnClear.UseVisualStyleBackColor = true;
            this.btnClear.Click += new System.EventHandler(this.btnClear_Click);
            // 
            // EncryptDecryptForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(390, 261);
            this.Controls.Add(this.btnClear);
            this.Controls.Add(this.lblErrorMessage);
            this.Controls.Add(this.lblPwdEncryptMessage);
            this.Controls.Add(this.lblUserEncryptMessage);
            this.Controls.Add(this.PwdEncrypt);
            this.Controls.Add(this.lblHashKey);
            this.Controls.Add(this.txtHaskkey);
            this.Controls.Add(this.UserEncrypt);
            this.Controls.Add(this.btnDecrypt);
            this.Controls.Add(this.btnEncrypt);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtPassword);
            this.Controls.Add(this.txtUserName);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "EncryptDecryptForm";
            this.Text = "Form1";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtUserName;
        private System.Windows.Forms.TextBox txtPassword;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btnEncrypt;
        private System.Windows.Forms.Button btnDecrypt;
        private System.Windows.Forms.Label UserEncrypt;
        private System.Windows.Forms.TextBox txtHaskkey;
        private System.Windows.Forms.Label lblHashKey;
        private System.Windows.Forms.Label PwdEncrypt;
        private System.Windows.Forms.Label lblUserEncryptMessage;
        private System.Windows.Forms.Label lblPwdEncryptMessage;
        private System.Windows.Forms.Label lblErrorMessage;
        private System.Windows.Forms.Button btnClear;
    }
}

