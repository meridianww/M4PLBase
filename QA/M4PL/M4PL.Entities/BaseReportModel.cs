/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 BaseReportModel
Purpose:                                      Contains objects related to BaseReportModel
==========================================================================================================*/
namespace M4PL.Entities
{
    public class BaseReportModel : BaseModel
    {
        public BaseReportModel()
        {
        }

        public BaseReportModel(BaseReportModel baseReportModel)
        {
            if (baseReportModel != null)
            {
                Id = baseReportModel.Id;
                LangCode = baseReportModel.LangCode;
                OrganizationId = baseReportModel.OrganizationId;
                RprtMainModuleId = baseReportModel.RprtMainModuleId;
                RprtName = baseReportModel.RprtName;
                RprtIsDefault = baseReportModel.RprtIsDefault;
            }
        }

        public int RprtMainModuleId { get; set; }

        public byte[] RprtTemplate { get; set; }

        public string RprtDescription { get; set; }

        public string RprtName { get; set; }

        bool? rprtIsDefault;
        public bool? RprtIsDefault { get { return rprtIsDefault; } set { rprtIsDefault = value == null ? false : value; } }
    }
}