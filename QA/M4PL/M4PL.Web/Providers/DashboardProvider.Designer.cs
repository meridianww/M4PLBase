namespace M4PL.Web.Providers
{
    partial class DashboardProvider
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            DevExpress.DataAccess.EntityFramework.EFConnectionParameters efConnectionParameters1 = new DevExpress.DataAccess.EntityFramework.EFConnectionParameters();
            this.M4PLDashboardDataSource = new DevExpress.DashboardCommon.DashboardEFDataSource();
            ((System.ComponentModel.ISupportInitialize)(this.M4PLDashboardDataSource)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this)).BeginInit();
            // 
            // M4PLDashboardDataSource
            // 
            this.M4PLDashboardDataSource.ComponentName = "M4PLDashboardDataSource";
            efConnectionParameters1.ConnectionString = "";
            efConnectionParameters1.ConnectionStringName = "DefaultConnection";
            efConnectionParameters1.Source = typeof(M4PL.EF.DefaultConnection);
            this.M4PLDashboardDataSource.ConnectionParameters = efConnectionParameters1;
            this.M4PLDashboardDataSource.Name = "M4PLDataSource";
            // 
            // DashboardProvider
            // 
            this.DataSources.AddRange(new DevExpress.DashboardCommon.IDashboardDataSource[] {
            this.M4PLDashboardDataSource});
            this.Title.Text = "Dashboard";
            ((System.ComponentModel.ISupportInitialize)(this.M4PLDashboardDataSource)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this)).EndInit();

        }

        #endregion

        private DevExpress.DashboardCommon.DashboardEFDataSource M4PLDashboardDataSource;
    }
}
