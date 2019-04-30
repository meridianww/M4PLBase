using M4PL.Web.Tests.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Contact
{
    public class ContactXPath
    {
       public const String contactDataViewScreen = "//li[@id='M4PLNavBar_I6i0_']//span[@class='dx-vam' and contains(text(),'Data View Screen')]";
       public const String newRibbonBtn = "//span[contains(text(),'New')]";
       public const String saveRibbonBtn = "//span[(contains(text(),'Save'))]";
       public const String firstName = "ConFirstName_I";
       public const String middleName = "//input[@id='ConMiddleName_I']";
       public const String lastName = "ConLastName_I";
       public const String jobTitle = "ConJobTitle_I";
       public const String companyName = "//input[@id='ConOrgId_I']";
       public const String conImage = "//div[@id='ConImage_EVP']";
       public const String businessPhone = "//input[@id='ConBusinessPhone_I']";
       public const String phoneExtension = "//input[@id='ConBusinessPhoneExt_I']";
       public const String homePhone = "//input[@id='ConHomePhone_I']";
       public const String mobilePhone = "//input[@id='ConMobilePhone_I']";
       public const String faxNumber = "//input[@id='ConFaxNumber_I']";
       public const String workEmail = "//input[@id='ConEmailAddress_I']";
       public const String indEmail = "ConEmailAddress2_I";
       public const String baLine1 = "//input[@id='ConBusinessAddress1_I']";
       public const String baLine2 = "//input[@id='ConBusinessAddress2_I']";
       public const String bCity = "//input[@id='ConBusinessCity_I']";
       public const String bState = "//input[@id='ConBusinessStateId_I']";
       public const String bZip = "//input[@id='ConBusinessZipPostal_I']";
       public const String bCountry = "//input[@id='ConBusinessCountryId_I']";
       public const String haLine1 = "//input[@id='ConHomeAddress1_I']";
       public const String haLine2 = "//input[@id='ConHomeAddress2_I']";
       public const String hCity = "//input[@id='ConHomeCity_I']";
       public const String hState = "//input[@id='ConHomeStateId_I']";
       public const String hZip = "//input[@id='ConHomeZipPostal_I']";
       public const String hCountry = "//input[@id='ConHomeCountryId_I']";
       public const String webPage = "//input[@id='ConWebPage_I']";
       public const String conType = "//input[@id='ConTypeId_I']";
       public const String conStatus = "//input[@id='StatusId_I']";
       public const String conNotes = "//textarea[@id='ConNotes_I']";
       public const String conSave = "//img[@id='btnContactSaveImg']";
       public const String conCancel = "//img[@id='btnContactCancelImg']";
       public const String conSaveOKBtn = "//div[@id='btnOk_CD']";

        public const string conLastNameVal = "ContentSplitter_1_CC";
        public const string conFirstNameVal = "";
        public const string conEmailBusPhnVal = "";
    }
}
