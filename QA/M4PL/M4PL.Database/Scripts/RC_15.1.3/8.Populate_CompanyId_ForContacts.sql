CREATE TABLE #CompanyContactRelation (
	CompanyId BIGINT
	,ContactId BIGINT
	)

INSERT INTO #CompanyContactRelation
SELECT Id CompanyId
	,10209 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10007
	AND CompTableName = 'Customer'

UNION

SELECT Id CompanyId
	,10210 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10007
	AND CompTableName = 'Customer'

UNION

SELECT Id CompanyId
	,10211 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10007
	AND CompTableName = 'Customer'

UNION

SELECT Id CompanyId
	,10212 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10007
	AND CompTableName = 'Customer'

UNION

SELECT Id CompanyId
	,10213 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10007
	AND CompTableName = 'Customer'

UNION

SELECT Id CompanyId
	,10544 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10007
	AND CompTableName = 'Customer'

UNION

SELECT Id CompanyId
	,10545 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10007
	AND CompTableName = 'Customer'

UNION

SELECT Id CompanyId
	,10020 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10007
	AND CompTableName = 'Customer'

UNION

SELECT Id CompanyId
	,10021 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10022 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10023 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10024 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10025 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10026 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10027 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10028 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10029 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10030 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10031 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10032 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10033 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10034 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10035 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10036 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10037 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10038 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10039 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10040 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10041 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10042 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10043 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10044 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10045 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10532 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10552 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10046 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 1
	AND CompTableName = 'Organization'

UNION

SELECT Id CompanyId
	,10047 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10003
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10048 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10003
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10049 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10003
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10050 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10003
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10051 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10004
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10052 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10004
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10053 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10004
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10054 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10055 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10056 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10057 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10058 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10059 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10006
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10060 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10006
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10061 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10007
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10062 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10008
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10063 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10008
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10064 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10008
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10065 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10066 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10067 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10068 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10069 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10070 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10012
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10071 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10013
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10072 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10014
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10073 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10015
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10074 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10015
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10075 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10076 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10017
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10077 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10017
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10078 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10017
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10079 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10017
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10080 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10018
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10081 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10018
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10082 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10083 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10020
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10084 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10085 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10020
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10086 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10087 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10088 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10010
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10089 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10009
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10090 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10009
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10091 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10009
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10092 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10006
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10093 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10021
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10094 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10021
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10095 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10021
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10096 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10097 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10098 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10099 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10023
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10100 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10023
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10101 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10023
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10102 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10024
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10103 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10024
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10104 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10024
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10105 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10106 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10107 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10108 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10048
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10109 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10048
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10110 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10048
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10111 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10026
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10112 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10113 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10026
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10114 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10115 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10116 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10117 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10028
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10118 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10028
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10119 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10028
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10120 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10029
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10121 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10029
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10122 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10029
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10123 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10124 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10125 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10126 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10030
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10127 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10030
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10128 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10030
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10129 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10031
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10130 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10031
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10131 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10031
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10132 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10133 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10134 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10135 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10136 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10137 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10138 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10139 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10140 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10141 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10142 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10143 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10144 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10145 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10146 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10147 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10148 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10149 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10150 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10151 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10152 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10034
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10153 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10034
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10154 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10034
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10155 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10049
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10156 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10049
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10157 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10049
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10158 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10035
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10159 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10035
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10160 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10035
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10161 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10036
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10163 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10036
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10164 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10037
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10165 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10037
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10166 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10037
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10167 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10038
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10168 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10038
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10169 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10038
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10170 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10038
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10171 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10038
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10172 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10038
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10173 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10038
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10174 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10038
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10175 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10038
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10176 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10177 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10178 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10179 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10040
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10180 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10181 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10182 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10183 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10042
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10184 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10042
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10185 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10042
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10186 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10187 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10188 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10189 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10190 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10191 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10192 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10193 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10194 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10195 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10196 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10197 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10043
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10198 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10044
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10199 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10044
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10200 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10044
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10201 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10045
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10202 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10045
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10203 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10045
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10204 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10046
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10205 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10046
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10206 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10046
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10207 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10047
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10208 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10047
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10214 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10047
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10215 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10216 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10217 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10218 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10219 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10220 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10221 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10222 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10223 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10224 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10225 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10226 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10227 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10228 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10229 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10230 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10231 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10232 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10233 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10234 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10235 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10236 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10237 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10238 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10239 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10240 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10241 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10242 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10243 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10244 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10245 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10246 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10247 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10248 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10249 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10250 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10251 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10252 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10253 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10254 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10255 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10256 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10257 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10258 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10259 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10260 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10005
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10261 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10262 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10263 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10264 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10265 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10266 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10267 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10268 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10027
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10269 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10270 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10271 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10272 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10273 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10274 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10009
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10275 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10009
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10276 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10009
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10277 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10009
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10278 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10279 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10280 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10281 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10282 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10283 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10284 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10285 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10286 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10287 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10288 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10289 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10290 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10291 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10292 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10293 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10051
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10294 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10035
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10295 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10035
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10296 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10035
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10297 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10021
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10298 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10021
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10299 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10021
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10300 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10021
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10301 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10021
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10302 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10021
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10303 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10304 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10305 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10306 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10307 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10308 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10309 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10310 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10311 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10312 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10313 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10314 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10315 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10316 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10317 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10318 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10319 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10320 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10321 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10322 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10323 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10324 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10325 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10326 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10327 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10328 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10329 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10330 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10331 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10332 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10333 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10334 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10335 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10336 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10337 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10338 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10339 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10022
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10340 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10341 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10342 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10343 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10344 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10345 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10346 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10347 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10348 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10054
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10349 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10054
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10350 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10040
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10351 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10040
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10352 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10040
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10353 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10040
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10354 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10040
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10355 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10040
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10356 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10040
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10357 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10358 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10359 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10360 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10361 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10362 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10363 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10039
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10364 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10365 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10366 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10367 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10041
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10368 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10369 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10370 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10371 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10372 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10373 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10374 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10375 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10376 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10025
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10377 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10052
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10378 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10052
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10379 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10052
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10380 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10052
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10381 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10052
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10382 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10383 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10384 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10385 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10386 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10387 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10388 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10389 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10390 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10391 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10392 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10393 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10394 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10395 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10055
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10396 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10397 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10020
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10398 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10399 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10008
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10400 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10008
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10401 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10008
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10402 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10008
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10403 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10404 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10405 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10406 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10407 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10408 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10409 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10010
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10410 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10010
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10411 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10010
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10412 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10010
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10413 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10010
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10414 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10015
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10415 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10015
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10416 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10023
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10417 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10023
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10418 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10023
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10419 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10023
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10420 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10023
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10421 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10422 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10423 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10424 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10425 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10426 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10427 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10428 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10429 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10430 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10431 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10432 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10433 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10434 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10435 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10049
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10439 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10049
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10440 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10441 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10442 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10443 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10444 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10445 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10446 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10447 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10448 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10449 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10450 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10451 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10452 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10453 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10454 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10455 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10011
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10456 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10457 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10458 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10459 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10460 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10461 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10047
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10462 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10047
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10463 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10047
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10464 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10057
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10465 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10057
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10466 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10057
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10467 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10057
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10468 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10057
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10469 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10057
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10470 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10471 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10472 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10473 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10474 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10475 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10476 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10477 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10478 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10479 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10480 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10481 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10482 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10483 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10484 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10485 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10486 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10487 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10488 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10489 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10016
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10490 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10491 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10492 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10493 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10494 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10495 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10496 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10019
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10497 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10059
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10498 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10059
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10499 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10054
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10500 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10050
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10501 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10060
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10502 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10057
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10503 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10062
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10504 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10062
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10505 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10062
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10506 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10063
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10507 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10063
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10508 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10063
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10509 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10015
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10510 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10015
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10511 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10017
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10512 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10513 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10514 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10515 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10058
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10516 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10003
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10517 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10003
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10518 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10003
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10519 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10060
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10520 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10023
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10521 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10032
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10522 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10049
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10523 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10036
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10524 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10036
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10525 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10526 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10004
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10527 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10004
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10528 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10012
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10529 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10530 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10531 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10533 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10033
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10535 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10040
	AND CompTableName = 'Vendor'

UNION

SELECT Id CompanyId
	,10162 ContactId
FROM dbo.COMP000Master
WHERE CompPrimaryRecordId = 10056
	AND CompTableName = 'Vendor'

UPDATE Contact
SET Contact.ConCompanyId = Com.CompanyId
FROM dbo.CONTC000Master Contact
INNER JOIN #CompanyContactRelation COM ON COM.ContactId = Contact.Id

DROP TABLE #CompanyContactRelation