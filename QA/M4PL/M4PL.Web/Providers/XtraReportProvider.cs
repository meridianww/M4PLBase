/// <summary>
/// Summary description for XtraReportProvider
/// </summary>
public class XtraReportProvider : DevExpress.XtraReports.UI.XtraReport
{
    private DevExpress.XtraReports.UI.DetailBand Detail;
    private DevExpress.XtraReports.UI.TopMarginBand TopMargin;
    private DevExpress.XtraReports.UI.BottomMarginBand BottomMargin;
    private DevExpress.DataAccess.EntityFramework.EFDataSource M4PLDataSource;

    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    public XtraReportProvider()
    {
        InitializeComponent();
        //
        // TODO: Add constructor logic here
        //
    }

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

    #region Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
        this.components = new System.ComponentModel.Container();
        DevExpress.DataAccess.EntityFramework.EFConnectionParameters efConnectionParameters1 = new DevExpress.DataAccess.EntityFramework.EFConnectionParameters();
        this.Detail = new DevExpress.XtraReports.UI.DetailBand();
        this.TopMargin = new DevExpress.XtraReports.UI.TopMarginBand();
        this.BottomMargin = new DevExpress.XtraReports.UI.BottomMarginBand();
        this.M4PLDataSource = new DevExpress.DataAccess.EntityFramework.EFDataSource(this.components);
        ((System.ComponentModel.ISupportInitialize)(this.M4PLDataSource)).BeginInit();
        ((System.ComponentModel.ISupportInitialize)(this)).BeginInit();
        //
        // Detail
        //
        this.Detail.HeightF = 100F;
        this.Detail.Name = "Detail";
        this.Detail.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
        this.Detail.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft;
        //
        // TopMargin
        //
        this.TopMargin.HeightF = 100F;
        this.TopMargin.Name = "TopMargin";
        this.TopMargin.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
        this.TopMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft;
        //
        // BottomMargin
        //
        this.BottomMargin.HeightF = 100F;
        this.BottomMargin.Name = "BottomMargin";
        this.BottomMargin.Padding = new DevExpress.XtraPrinting.PaddingInfo(0, 0, 0, 0, 100F);
        this.BottomMargin.TextAlignment = DevExpress.XtraPrinting.TextAlignment.TopLeft;
        //
        // M4PLDataSource
        //
        efConnectionParameters1.ConnectionString = string.Empty;
        efConnectionParameters1.ConnectionStringName = "DefaultConnection";
        efConnectionParameters1.Source = typeof(M4PL.EF.DefaultConnection);
        this.M4PLDataSource.ConnectionParameters = efConnectionParameters1;
        this.M4PLDataSource.Name = "M4PLDataSource";
        //
        // XtraReportProvider
        //
        this.Bands.AddRange(new DevExpress.XtraReports.UI.Band[] {
            this.Detail,
            this.TopMargin,
            this.BottomMargin});
        this.ComponentStorage.AddRange(new System.ComponentModel.IComponent[] {
            this.M4PLDataSource});
        this.DataMember = "CONTC000Master";
        this.DataSource = this.M4PLDataSource;
        this.Version = "17.2";
        ((System.ComponentModel.ISupportInitialize)(this.M4PLDataSource)).EndInit();
        ((System.ComponentModel.ISupportInitialize)(this)).EndInit();
    }

    #endregion Designer generated code
}