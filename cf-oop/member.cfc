<cfcomponent description="mbr Component" output="false" hint="business logic to manage the data for mbr">

	<cffunction name="getmbrListPagination" access="public" returntype="query">
		<cfargument name="lastName" type="string" required="no" default="" />
		<cfargument name="firstName" type="string" required="no" default="" />
		<cfargument name="email" type="string" required="no" default="" />
		<cfargument name="salonNameLike" type="string" required="no" default="" />
		<cfargument name="salonCityLike" type="string" required="no" default="" />
		<cfargument name="salonStateLike" type="string" required="no" default="" />
		<cfargument name="phone" type="string" required="no" default="" />
		<cfargument name="distributorAcctNumLike" type="string" required="no" default="" />
		<cfargument name="mbrID" type="string" required="no" default="" />
		<cfargument name="optOut" type="string" required="no" default="" />
		<cfargument name="distributorID" type="string" required="no" default="" />
		<cfargument name="distributorTerrID" type="string" required="no" default="" />
		<cfargument name="mbrStatusID" type="string" required="no" default="" />
		<cfargument name="discountTypeID" type="string" required="no" default="" />
		<cfargument name="mbrTierID" type="string" required="no" default="" />
		<cfargument name="startDTMCreated" type="string" required="no" default="" />
		<cfargument name="endDTMCreated" type="string" required="no" default="" />
		<cfargument name="mbrTypeID" type="string" required="no" default="" />
		<cfargument name="mbrStatusPendingApproval" type="string" required="no" default="" />
		<cfargument name="matchType" type="string" required="no" default="Exact" />
		<cfargument name="maxRows" type="string" required="no"  default="500" />
		<cfargument name="orderBy" type="string" required="no"  default="M.FirstName, M.LastName" />
		<cfargument name="pageNumber" type="numeric" required="false" default="1" />
		<cfargument name="distributorIDAccess" type="string" required="no" default="" />
		<cfargument name="distributorTerrIDAccess" type="string" required="no" default="" />
		<cfargument name="stateAccess" type="string" required="no" default="" />
		<!--- <cfargument name="OribeAcctNum" type="string" required="no" default="" /> --->
		<cfargument name="hasOribeAcctNum" type="string" required="no" default="" />
		<cfargument name="termsAccepted" type="string" required="no" default="" />
		<cfargument name="grandfatheredTitanium" type="string" required="no" default="" />
		<cfargument name="country" type="string" required="no" default="" />
		<cfargument name="countryAccess" type="string" required="no" default="" />
		<cfargument name="excel" type="string" required="no" default="" />
		<cfargument name="langUID" required="no" />
		<cfargument name="clientUID" required="no" />
		<cfargument name="emailConfirmedCanada" type="boolean" required="false" />
		<cfargument name="emailConfirmedDTM" type="date" required="false" />
		<cfargument name="jBPCompleted" type="string" required="false" />

		<cfset var qry = "" />
		<cfset var startRecord = ((arguments.pageNumber-1)*arguments.maxRows)+1 />
		<cfset var endRecord = (arguments.pageNumber*arguments.maxRows) />
		<cfset var mMatchTypePrefix = "" />
		<cfset var mMatchTypeSuffix = "" />

		<!--- Match Type Logic --->
		<cfif arguments.matchType EQ "Contains">
			<cfset mMatchTypePrefix = "%">
			<cfset mMatchTypeSuffix = "%">
		<cfelseif arguments.matchType EQ "Starts">
			<cfset mMatchTypeSuffix = "%">
		</cfif>

		<cfquery name="qry">
			declare @ExpirationDTM datetime

			set @ExpirationDTM = DATEADD(m, DATEDIFF(m, -1, current_timestamp), 0)

			SELECT RowNumber,
					TotalRows,
					CEILING(TotalRows/CAST(500 AS Decimal(10,2))) as TotalPage,
					mbrID,
					FirstName,
					LastName,
					EmailAddress,
					LastLogin,
					Address1,
					Address2,
					City,
					State,
					ZipCode,
					Country,
					Phone,
					DTMCreated,
					OribeAcctNum,
					mbrStatusName,
					DiscountTypeName,
					PointBalance,
					RedeemedPointsYTD,
					EarnedPointsYTD,
					TierName,
					Nickname,
					mbrSalonID,
					SalonName,
					SalonAddress1,
					SalonAddress2,
					SalonCity,
					SalonState,
					SalonCountry,
					SalonPhone,
					SalonFinderID,
					TerrLabel,
					TerrCode,
					Relationship,
					mbrTypeName,
					GrandfatheredTitanium,
					<cfif arguments.excel EQ 1>
						YTDSales,
						OribeYtdPoints,
						DistributorAcctNumList,
						SalonNameList,
						SalonAddress1List,
						SalonAddress2List,
						SalonCityList,
						SalonStateList,
						SalonZipCodeList,
						SalonCountryList,
						SalonPhoneList,
						SalonFinderIDList,
						FormStatusCode,
						LastUpdateDTM,
					</cfif>
					HasOribeAcctNum
					, langUID
					, clientUID
					, emailConfirmedCanada
					, emailConfirmedDTM
					, optOutCanada
					, ISNULL(ExpirationPoints,0) AS ExpirationPoints
			FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY #arguments.orderBy#) AS RowNumber, Count(*) OVER() AS TotalRows,
						M.mbrID,
						M.FirstName,
						M.LastName,
						M.EmailAddress,
						M.LastLogin,
						M.Address1,
						M.Address2,
						M.City,
						M.State,
						M.ZipCode,
						M.Country,
						M.Phone,
						M.DTMCreated,
						MON.OribeAcctNum,
						MS.mbrStatusName,
						DTY.DiscountTypeName,
						IsNull(VMTS.PointBalance, 0) AS PointBalance,
						IsNull(VMTS.RedeemedPointsYTD, 0) AS RedeemedPointsYTD,
						IsNull(VMTS.EarnedPointsYTD, 0) AS EarnedPointsYTD,
						MTI.TierName,
						D.Nickname,
						MSAL.mbrSalonID,
						MSAL.SalonName,
						MSAL.Address1 AS SalonAddress1,
						MSAL.Address2 AS SalonAddress2,
						MSAL.City AS SalonCity,
						MSAL.State AS SalonState,
						MSAL.Country AS SalonCountry,
						MSAL.Phone AS SalonPhone,
						MSAL.SalonFinderID,
						MSAL.IsMaster,
						DT.TerrLabel,
						DT.TerrCode,
						MSR.Relationship,
						MT.mbrTypeName,
						case when M.mbrTierID = 4 then dbo.udf_TitaniumGrandfatherLvl(M.mbrID) else null end as GrandfatheredTitanium,
						<cfif arguments.excel EQ 1>
							IsNull(VMSS.YTDSales, 0) AS YTDSales,
							OribeYtd.Points AS OribeYtdPoints,
							dbo.ufn_GetDistributorAcctNumList(M.mbrID) AS DistributorAcctNumList,
							X.SalonName AS SalonNameList,
							X.Address1 AS SalonAddress1List,
							X.Address2 AS SalonAddress2List,
							X.City AS SalonCityList,
							X.State AS SalonStateList,
							X.ZipCode AS SalonZipCodeList,
							X.Country AS SalonCountryList,
							X.Phone AS SalonPhoneList,
							X.SalonFinderID AS SalonFinderIDList,
							FA.LastUpdateDTM AS LastUpdateDTM,
							FA.FormStatusCode AS FormStatusCode,
						</cfif>
						CASE WHEN IsNull(MON.OribeAcctNum, '') <> '' THEN 1 ELSE 0 END AS HasOribeAcctNum
						, m.langUID
						, m.clientUID
						, m.emailConfirmedCanada
						, m.emailConfirmedDTM
						, m.optOutCanada,
						(
							select sum(isnull(Points,0) - isnull(ExpiredPoints,0) - isnull(PointsRedeemed,0)) as ExpirationPoints
							from dbo.mbrTransaction with(nolock)
							where mbrID = M.mbrID
								and IsActive = 1
								and ExpirationDTM = @ExpirationDTM
						) as ExpirationPoints
					FROM mbr M WITH(NOLOCK)
						LEFT JOIN mbrStatus MS WITH(NOLOCK) ON M.mbrStatusID = MS.mbrStatusID
						LEFT JOIN DiscountType DTY WITH(NOLOCK) ON M.DiscountTypeID = DTY.DiscountTypeID
						LEFT JOIN mbrType MT WITH(NOLOCK) ON M.mbrTypeID = MT.mbrTypeID
						LEFT JOIN Country C WITH(NOLOCK) ON M.Country = C.CountryName
						LEFT JOIN SecurityQuestion SQ WITH(NOLOCK) ON SQ.SecurityQuestionID = M.SecurityQuestionID
						LEFT JOIN view_mbrTransactionSummary VMTS WITH(NOLOCK) ON M.mbrID = VMTS.mbrID
						LEFT JOIN mbrTier MTI WITH(NOLOCK) ON M.mbrTierID = MTI.mbrTierID
						LEFT JOIN Distributor D WITH(NOLOCK) ON M.DistributorID = D.DistributorID
						LEFT JOIN DistributorTerr DT WITH(NOLOCK) ON M.DistributorTerrID = DT.DistributorTerrID
						LEFT JOIN mbrSalonRelationship MSR WITH(NOLOCK) ON M.mbrSalonRelationshipID = MSR.mbrSalonRelationshipID
						<!---
						--LEFT JOIN (
						--			SELECT mbrID, MIN(AcctNum) AS OribeAcctNum, MAX(LastUpdateDTM) AS OribeAcctNumLoadDTM
						--			FROM mbrExternalAccount WITH(NOLOCK)
						--			WHERE DTMArchived IS NULL AND AccountType = <cfqueryparam value="Oribe" CFSQLType="CF_SQL_VARCHAR">
						--			GROUP BY mbrID
						--	) AS MON ON M.mbrID = MON.mbrID
						--->
						LEFT JOIN (
									SELECT mbrID, MIN(DistributorAcctNum) AS OribeAcctNum
									FROM mbrDistributor WITH(NOLOCK)
									WHERE IsActive = 1
									AND DistributorID IN (SELECT DistributorID FROM Distributor WITH(NOLOCK) WHERE distributorUID IN ('3CA41F79-E4AA-49B7-A3FF-15F677D39AAF', 'B81AB138-0881-444F-9A12-C9D9605F553D'))
									GROUP BY mbrID
						) AS MON ON M.mbrID = MON.mbrID

						<cfif arguments.excel EQ 1>

						LEFT JOIN view_mbrSaleSummary VMSS WITH(NOLOCK) ON M.mbrID = VMSS.mbrID
						OUTER APPLY (
							SELECT TOP 1 MA.mbrID, IsNull(SUM(MA.Points), 0) AS Points
							FROM mbrAdjustment MA WITH(NOLOCK)
							WHERE 1=1
								AND MA.IsActive = 1
								AND MA.mbrAdjustmentTypeID = 5
								AND MA.mbrID = M.mbrID
								AND MA.AdjustmentDTM >= <cfqueryparam value="#dateFormat(NOW(), '01/01/yyyy')#" CFSQLType="CF_SQL_VARCHAR">
							GROUP BY MA.mbrID
						) AS OribeYtd
						OUTER APPLY (
							SELECT TOP 1 MA.mbrID, IsNull(SUM(MA.Points), 0) AS Points
							FROM mbrAdjustment MA WITH(NOLOCK)
							WHERE 1=1
								AND MA.IsActive = 1
								AND MA.mbrAdjustmentTypeID = 7
								AND MA.mbrID = M.mbrID
								AND MA.AdjustmentDTM >= <cfqueryparam value="#dateFormat(NOW(), '01/01/yyyy')#" CFSQLType="CF_SQL_VARCHAR">
							GROUP BY MA.mbrID
						) AS ArrojoYtd
						OUTER APPLY dbo.udf_mbrSalonData(M.mbrID) AS X
						OUTER APPLY (
							SELECT TOP 1 FA.LastUpdateDTM, FormStatusCode
							FROM FormAnswer FA WITH(NOLOCK)
							WHERE 1=1
								AND FA.IsActive = 1
								AND FA.mbrID = M.mbrID
								<cfif len(trim(arguments.jBPCompleted))>AND FA.FormStatusCode = <cfqueryparam value="#arguments.jBPCompleted#" CFSQLType="CF_SQL_VARCHAR"></cfif>
							ORDER BY FA.LastUpdateDTM DESC
						) AS FA

						</cfif>

						OUTER APPLY (
							SELECT TOP 1
								mbrSalonID,
								SalonName,
								Address1,
								Address2,
								City,
								State,
								Country,
								Phone,
								SalonFinderID,
								IsMaster
							FROM mbrSalon WITH(NOLOCK)
							WHERE 1=1
								AND IsActive = 1
								AND mbrID = M.mbrID
							ORDER BY IsMaster desc

						) AS MSAL
					WHERE 1=1
						AND M.IsActive = 1



						<cfif structKeyExists(ARGUMENTS,"clientUID") AND len(trim(arguments.clientUID))>
							AND M.clientUID = <cfqueryparam value="#arguments.clientUID#" CFSQLType="CF_SQL_idstamp">
						</cfif>
						<cfif len(trim(arguments.country))>
							AND M.Country = <cfqueryparam value="#arguments.country#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.countryAccess))>
			              	AND M.Country IN (<cfqueryparam value="#arguments.countryAccess#" CFSQLType="CF_SQL_VARCHAR" List="true">)
			            </cfif>
						<cfif len(trim(arguments.grandfatheredTitanium))>
							AND case when M.mbrTierID = 4 then dbo.udf_TitaniumGrandfatherLvl(M.mbrID) else null end = <cfqueryparam value="#arguments.grandfatheredTitanium#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif arguments.termsAccepted EQ 1>
							AND IsNull(M.TermsAcceptanceDTM, '1/1/1900') > '1/1/1900'
						<CFELSEIF arguments.termsAccepted EQ 0>
							AND IsNull(M.TermsAcceptanceDTM, '1/1/1900') = '1/1/1900'
						</cfif>
						<cfif arguments.hasOribeAcctNum EQ 1>
							AND IsNull(MON.OribeAcctNum, '') <> ''
						<CFELSEIF arguments.hasOribeAcctNum EQ 0>
							AND IsNull(MON.OribeAcctNum, '') = ''
						</cfif>
						<cfif arguments.mbrStatusPendingApproval EQ 1>
							AND M.mbrStatusID = 3
						<CFELSEIF arguments.mbrStatusPendingApproval EQ 0>
							AND M.mbrStatusID <> 3
						</cfif>
						<cfif len(trim(arguments.mbrTypeID))>
							AND M.mbrTypeID = <cfqueryparam value="#arguments.mbrTypeID#" CFSQLType="CF_SQL_INTEGER">
						</cfif>
						<cfif len(trim(arguments.optOut))>
							AND M.OptOut = <cfqueryparam value="#arguments.optOut#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.emailLike))>
							AND M.EmailAddress LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.emailLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif IsNumeric(arguments.mbrIDLike)>
							AND M.mbrID LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.mbrIDLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.firstNameLike))>
							AND M.FirstName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.firstNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.lastNameLike))>
							AND M.LastName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.lastNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.phoneLike))>
							AND M.Phone LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.phoneLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.salonNameLike))>
							AND M.mbrID IN (
													SELECT mbrID
													FROM mbrSalon WITH(NOLOCK)
													WHERE 1=1
														AND IsActive = 1
														AND SalonName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.salonNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
											)
						</cfif>
						<cfif len(trim(arguments.salonCityLike))>
							AND M.mbrID IN (
													SELECT mbrID
													FROM mbrSalon WITH(NOLOCK)
													WHERE 1=1
														AND IsActive = 1
														AND City LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.salonCityLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
											)
						</cfif>
						<cfif len(trim(arguments.salonStateLike))>
							AND M.mbrID IN (
													SELECT mbrID
													FROM mbrSalon WITH(NOLOCK)
													WHERE 1=1
														AND IsActive = 1
														AND State LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.salonStateLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
											)
						</cfif>
						<cfif len(trim(arguments.distributorAcctNumLike))>
							AND M.mbrID IN (
													SELECT mbrID
													FROM mbrDistributor WITH(NOLOCK)
													WHERE 1=1
														AND IsActive = 1
														AND DistributorAcctNum LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.distributorAcctNumLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
											)
						</cfif>
						<cfif len(trim(arguments.distributorIDAccess))>
							AND M.DistributorID IN (<cfqueryparam value="#arguments.distributorIDAccess#" CFSQLType="CF_SQL_VARCHAR" list="true">)
						</cfif>
						<cfif len(trim(arguments.distributorTerrIDAccess))>
							AND M.DistributorTerrID IN (<cfqueryparam value="#arguments.distributorTerrIDAccess#" CFSQLType="CF_SQL_VARCHAR" list="true">)
						</cfif>
						<cfif len(trim(arguments.stateAccess))>
							AND M.State IN (<cfqueryparam value="#arguments.stateAccess#" CFSQLType="CF_SQL_VARCHAR" list="true">)
						</cfif>
						<cfif len(trim(arguments.distributorID))>
							<cfif arguments.distributorID EQ 0>
								AND D.DistributorID IS NULL
							<cfelse>
								AND D.DistributorID IN (<cfqueryparam value="#arguments.distributorID#" CFSQLType="CF_SQL_VARCHAR" list="true">)
							</cfif>
						</cfif>
						<cfif len(trim(arguments.distributorTerrID))>
							AND M.DistributorTerrID = <cfqueryparam value="#arguments.distributorTerrID#" CFSQLType="CF_SQL_INTEGER">
						</cfif>
						<cfif len(trim(arguments.mbrID))>
							AND M.mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
						</cfif>
						<cfif len(trim(arguments.mbrStatusID))>
							AND M.mbrStatusID = <cfqueryparam value="#arguments.mbrStatusID#" CFSQLType="CF_SQL_INTEGER">
						</cfif>
						<cfif len(trim(arguments.discountTypeID))>
							AND M.DiscountTypeID = <cfqueryparam value="#arguments.discountTypeID#" CFSQLType="CF_SQL_INTEGER">
						</cfif>
						<cfif len(trim(arguments.mbrTierID))>
							AND M.mbrTierID = <cfqueryparam value="#arguments.mbrTierID#" CFSQLType="CF_SQL_INTEGER">
						</cfif>
						<cfif len(trim(arguments.firstName))>
							AND M.FirstName = <cfqueryparam value="#arguments.firstName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
						</cfif>
						<cfif len(trim(arguments.lastName))>
							AND M.LastName = <cfqueryparam value="#arguments.lastName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
						</cfif>
						<cfif len(trim(arguments.email))>
							AND M.EmailAddress = <cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
						</cfif>
						<cfif len(trim(arguments.phone))>
							AND M.Phone = <cfqueryparam value="#arguments.phone#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
						</cfif>
						<cfif len(trim(arguments.startDTMCreated))>
							AND M.DTMCreated >= <cfqueryparam value="#arguments.startDTMCreated#" CFSQLType="CF_SQL_DTM">
						</cfif>
						<cfif len(trim(arguments.endDTMCreated))>
							AND M.DTMCreated < <cfqueryparam value="#dateFormat(dateAdd('d', 1, arguments.endDTMCreated), 'mm/dd/yyyy')#" CFSQLType="CF_SQL_DTM">
						</cfif>

						<!---
						<cfif len(trim(arguments.oribeAcctNum))>
							AND EXISTS (
								SELECT AcctNum
								FROM mbrExternalAccount WITH(NOLOCK)
								WHERE mbrExternalAccount.DTMArchived IS NULL
									AND mbrExternalAccount.mbrID = M.mbrID
									AND mbrExternalAccount.AccountType = <cfqueryparam value="Oribe" CFSQLType="CF_SQL_VARCHAR">
									AND mbrExternalAccount.AcctNum = <cfqueryparam value="#arguments.oribeAcctNum#" CFSQLType="CF_SQL_VARCHAR">
							)
						</cfif>
						--->

						<cfif len(trim(arguments.jBPCompleted))>
							AND EXISTS (
								SELECT TOP 1 LastUpdateDTM, FormStatusCode
								FROM FormAnswer WITH(NOLOCK)
								WHERE 1=1
									AND IsActive = 1
									AND mbrID = M.mbrID
									<cfif len(trim(arguments.jBPCompleted))>AND FormStatusCode = <cfqueryparam value="#arguments.jBPCompleted#" CFSQLType="CF_SQL_VARCHAR"></cfif>
							)

						</cfif>
			) AS pagination
			WHERE RowNumber BETWEEN <cfqueryparam value="#startRecord#" CFSQLType="CF_SQL_INTEGER"> AND <cfqueryparam value="#endRecord#" CFSQLType="CF_SQL_INTEGER">
			ORDER BY RowNumber
		</cfquery>

		<cfreturn qry>
	</cffunction>

	<cffunction name="getmbrType" access="public" returntype="query">
		<cfargument name="maxRows" type="numeric" required="no"  default="500" >
		<cfargument name="orderBy" type="string" required="no"  default="M.mbrTypeName">
		<cfargument name="mbrTypeName" type="string" required="no"  default="">
		<cfset var qry = "">

		<cfquery name="qry">
			SELECT TOP (<cfqueryparam value="#arguments.maxRows#" CFSQLType="CF_SQL_INTEGER">) M.mbrTypeID, M.mbrTypeName
			FROM mbrType M WITH(NOLOCK)
			WHERE M.IsActive=1
			<cfif len(trim(arguments.mbrTypeName))>
				AND m.mbrTypeName = <cfqueryparam value="#arguments.mbrTypeName#" CFSQLType="cf_sql_varchar" maxlength="500">
			</cfif>
			ORDER BY #arguments.orderBy#
		</cfquery>

		<cfreturn qry>
	</cffunction>

	<cffunction name="getmbr" access="public" returntype="query">
		<cfargument name="mbrID" type="string" required="no" default="">
		<cfargument name="notmbrID" type="string" required="no" default="">
		<cfargument name="isActive" type="string" required="no" default="1">
		<cfargument name="dateCreated" type="string" required="no" default="">
		<cfargument name="lastUpdateDTM" type="string" required="no" default="">
		<cfargument name="createUserID" type="string" required="no" default="">
		<cfargument name="lastUpdateUserID" type="string" required="no" default="">
		<cfargument name="mbrStatusID" type="string" required="no" default="">
		<cfargument name="discountTypeID" type="string" required="no" default="">
		<cfargument name="mbrTypeID" type="string" required="no" default="">
		<cfargument name="mbrTierID" type="string" required="no" default="">
		<cfargument name="firstName" type="string" required="no" default="">
		<cfargument name="lastName" type="string" required="no" default="">
		<cfargument name="email" type="string" required="no" default="">
		<cfargument name="password" type="string" required="no" default="">
		<cfargument name="address1" type="string" required="no" default="">
		<cfargument name="address2" type="string" required="no" default="">
		<cfargument name="city" type="string" required="no" default="">
		<cfargument name="state" type="string" required="no" default="">
		<cfargument name="zip" type="string" required="no" default="">
		<cfargument name="country" type="string" required="no" default="">
		<cfargument name="countryAccess" type="string" required="no" default="" />
		<cfargument name="phone" type="string" required="no" default="">
		<cfargument name="lastLogin" type="string" required="no" default="">
		<cfargument name="startDTMCreated" type="string" required="no" default="">
		<cfargument name="endDTMCreated" type="string" required="no" default="">
		<cfargument name="distributorID" type="string" required="no" default="">
		<cfargument name="distributorTerrID" type="string" required="no" default="">
		<cfargument name="distributorIDAccess" type="string" required="no" default="">
		<cfargument name="distributorTerrIDAccess" type="string" required="no" default="">
		<cfargument name="stateAccess" type="string" required="no" default="">
		<cfargument name="emailLike" type="string" required="no" default="">
		<cfargument name="mbrIDLike" type="string" required="no" default="">
		<cfargument name="firstNameLike" type="string" required="no" default="">
		<cfargument name="lastNameLike" type="string" required="no" default="">
		<cfargument name="phoneLike" type="string" required="no" default="">
		<cfargument name="salonNameLike" type="string" required="no" default="">
		<cfargument name="salonCityLike" type="string" required="no" default="">
		<cfargument name="salonStateLike" type="string" required="no" default="">
		<cfargument name="distributorNameLike" type="string" required="no" default="">
		<cfargument name="distributorAcctNumLike" type="string" required="no" default="">
		<cfargument name="optOut" type="string" required="no" default="">
		<cfargument name="mbrStatusPendingApproval" type="string" required="no" default="">
		<cfargument name="parentmbrID" type="string" required="no" default="">
		<cfargument name="matchType" type="string" required="no" default="Exact">
		<cfargument name="maxRows" type="string" required="no"  default="500">
		<cfargument name="orderBy" type="string" required="no"  default="M.FirstName, M.LastName">
		<cfargument name="pageNumber" type="numeric" required="false" default="1" />
		<cfargument name="langUID" required="no" />
		<cfargument name="clientUID" required="no" />
		<cfargument name="emailConfirmedCanada" type="boolean" required="false" />
		<cfargument name="emailConfirmedDTM" type="date" required="false" />

		<cfset var qry = "">
		<cfset var startRecord = ((arguments.pageNumber-1)*arguments.maxRows)+1 />
		<cfset var endRecord = (arguments.pageNumber*arguments.maxRows)/>
		<cfset var mMatchTypePrefix = "">
		<cfset var mMatchTypeSuffix = "">

		<!--- Match Type Logic --->
		<cfif arguments.matchType EQ "Contains">
			<cfset mMatchTypePrefix = "%">
			<cfset mMatchTypeSuffix = "%">
		<cfelseif arguments.matchType EQ "Starts">
			<cfset mMatchTypeSuffix = "%">
		</cfif>

		<cfquery name="qry">
			WITH pagination AS
			(
				SELECT ROW_NUMBER() OVER (ORDER BY #arguments.orderBy#) AS RowNumber, Count(*) OVER() AS TotalRows,
					M.mbrID,
					M.IsActive,
					M.DTMCreated,
					M.LastUpdateDTM,
					M.CreateUserID,
					M.LastUpdateUserID,
					M.mbrStatusID,
					M.DiscountTypeID,
					M.mbrTypeID,
					M.mbrTierID,
					M.FirstName,
					M.LastName,
					M.EmailAddress,
					dbo.ufn_decrypt(M.Password) AS Password,
					M.Address1,
					M.Address2,
					M.City,
					M.State,
					M.ZipCode,
					M.Country,
					M.Phone,
					M.LastLogin,
					M.SecurityQuestionID,
					M.SecurityQuestionAnswer,
					M.OptOut,
					M.DistributorID,
					M.DistributorTerrID,
					M.Distributor2ID,
					M.DistributorTerr2ID,
					M.TermsAcceptanceDTM,
					M.mbrSalonRelationshipID,
					M.IsForceProfile,
					MON.OribeAcctNum,
					CASE
						WHEN IsNumeric(M.Phone) = 1 AND len(M.Phone) = 10 THEN '(' + left(M.Phone,3) + ') ' + Substring(M.Phone, 3, 3) + '-' + Right(M.Phone,4)
						WHEN IsNumeric(M.Phone) = 1 AND len(M.Phone) = 7 THEN Left(M.Phone, 3) + '-' + Right(M.Phone,4)
						ELSE M.Phone
					END AS PhoneFormatted,
					M.EMOptOutDTM,
					M.BounceStatus,
					M.BounceReason,
					CASE
						WHEN IsNull(M.ProfileImage,'') <> '' THEN M.ProfileImage
						ELSE '/assets/images/profile_default.jpg'
					END AS ProfileImage,
					M.Bio,
					M.Profession,
					M.GrandfatheredTitanium,
					M.ParentmbrID,
					MS.mbrStatusName,
					MS.IsAllowLogin,
					isnull(MS.IsAllowPointEarning,0) AS IsAllowPointEarning,
					DTY.DiscountTypeName,
					DTY.Multiplier,
					MT.mbrTypeName,
					CASE
						WHEN M.mbrTierID in (4,8) THEN
							(
								SELECT top 1 SystemConfigValue
								FROM SystemConfig WITH(NOLOCK)
								WHERE IsActive = 1
									AND SystemConfigName = 'Titanium API Key'
									AND clientUID = m.clientUID
							)
						ELSE C.ApiKey
					END AS ApiKey,
					SQ.Question,
					IsNull(VMTS.PointBalance, 0) AS PointBalance,
					IsNull(VMTS.RedeemedPoints, 0) AS RedeemedPoints,
					IsNull(VMTS.EarnedPoints, 0) AS EarnedPoints,
					IsNull(VMTS.ExpiredPoints, 0) AS ExpiredPoints,
					IsNull(VMTS.RedeemedPointsYTD, 0) AS RedeemedPointsYTD,
					IsNull(VMTS.EarnedPointsYTD, 0) AS EarnedPointsYTD,
					MTI.TierName,
					D.DistributorName,
					D.Nickname,
					DT.TerrLabel,
					DT.TerrCode,
					DT.TerrName,
					DB.DistributorName AS DistributorNameB,
					DB.Nickname AS NicknameB,
					DTB.TerrLabel AS TerrLabelB,
					DTB.TerrCode AS TerrCodeB,
					DTB.TerrName AS TerrNameB,
					MSR.Relationship,
					MSAL.SalonName,
					MSAL.phone businessPhone
					, m.langUID
					, m.ClientUID
					, m.emailConfirmedCanada
					, m.emailConfirmedDTM
					, m.optOutCanada
				FROM mbr M WITH(NOLOCK)
					LEFT JOIN mbrStatus MS WITH(NOLOCK) ON M.mbrStatusID = MS.mbrStatusID
					LEFT JOIN DiscountType DTY WITH(NOLOCK) ON M.DiscountTypeID = DTY.DiscountTypeID
					LEFT JOIN mbrType MT WITH(NOLOCK) ON M.mbrTypeID = MT.mbrTypeID
					LEFT JOIN Country C WITH(NOLOCK) ON M.Country = C.CountryName
					LEFT JOIN SecurityQuestion SQ WITH(NOLOCK) ON SQ.SecurityQuestionID = M.SecurityQuestionID
					LEFT JOIN view_mbrTransactionSummary VMTS WITH(NOLOCK) ON M.mbrID = VMTS.mbrID
					LEFT JOIN mbrTier MTI WITH(NOLOCK) ON M.mbrTierID = MTI.mbrTierID
					LEFT JOIN Distributor D WITH(NOLOCK) ON M.DistributorID = D.DistributorID
					LEFT JOIN DistributorTerr DT WITH(NOLOCK) ON M.DistributorTerrID = DT.DistributorTerrID
					LEFT JOIN Distributor DB WITH(NOLOCK) ON M.Distributor2ID = DB.DistributorID
					LEFT JOIN DistributorTerr DTB WITH(NOLOCK) ON M.DistributorTerr2ID = DTB.DistributorTerrID
					LEFT JOIN mbrSalonRelationship MSR WITH(NOLOCK) ON M.mbrSalonRelationshipID = MSR.mbrSalonRelationshipID
					LEFT JOIN (
									SELECT MIN(mbrSalonID) AS mbrSalonID, mbrID,MIN(phone) phone
									FROM mbrSalon
									WHERE 1=1
										AND IsActive = 1
									GROUP BY mbrID
							) AS MSA ON M.mbrID = MSA.mbrID
					LEFT JOIN mbrSalon MSAL ON MSA.mbrSalonID = MSAL.mbrSalonID

					<!---
					LEFT JOIN (
									SELECT mbrID, MIN(AcctNum) AS OribeAcctNum, MAX(LastUpdateDTM) AS OribeAcctNumLoadDTM
									FROM mbrExternalAccount WITH(NOLOCK)
									WHERE DTMArchived IS NULL AND AccountType = <cfqueryparam value="Oribe" CFSQLType="CF_SQL_VARCHAR">
									GROUP BY mbrID
							) AS MON ON M.mbrID = MON.mbrID
					--->

					LEFT JOIN (
									SELECT mbrID, MIN(DistributorAcctNum) AS OribeAcctNum
									FROM mbrDistributor WITH(NOLOCK)
									WHERE IsActive = 1
									AND DistributorID IN (SELECT DistributorID FROM Distributor WITH(NOLOCK) WHERE distributorUID IN ('3CA41F79-E4AA-49B7-A3FF-15F677D39AAF', 'B81AB138-0881-444F-9A12-C9D9605F553D'))
									GROUP BY mbrID
							) AS MON ON M.mbrID = MON.mbrID

				WHERE 1=1
					<cfif len(trim(arguments.parentmbrID))>
						AND M.ParentmbrID = <cfqueryparam value="#arguments.parentmbrID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif arguments.mbrStatusPendingApproval EQ 1>
						AND M.mbrStatusID = 3
					<CFELSEIF arguments.mbrStatusPendingApproval EQ 0>
						AND M.mbrStatusID <> 3
					</cfif>
					<cfif len(trim(arguments.mbrTypeID))>
						AND M.mbrTypeID = <cfqueryparam value="#arguments.mbrTypeID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif len(trim(arguments.optOut))>
						AND M.OptOut = <cfqueryparam value="#arguments.optOut#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.emailLike))>
						AND M.EmailAddress LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.emailLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif IsNumeric(arguments.mbrIDLike)>
						AND M.mbrID LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.mbrIDLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.firstNameLike))>
						AND M.FirstName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.firstNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.lastNameLike))>
						AND M.LastName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.lastNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.phoneLike))>
						AND M.Phone LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.phoneLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.salonNameLike))>
						AND M.mbrID IN (
												SELECT mbrID
												FROM mbrSalon WITH(NOLOCK)
												WHERE 1=1
													AND IsActive = 1
													AND SalonName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.salonNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
										)
					</cfif>
					<cfif len(trim(arguments.salonCityLike))>
						AND M.mbrID IN (
												SELECT mbrID
												FROM mbrSalon WITH(NOLOCK)
												WHERE 1=1
													AND IsActive = 1
													AND City LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.salonCityLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
										)
					</cfif>
					<cfif len(trim(arguments.salonStateLike))>
						AND M.mbrID IN (
												SELECT mbrID
												FROM mbrSalon WITH(NOLOCK)
												WHERE 1=1
													AND IsActive = 1
													AND State LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.salonStateLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
										)
					</cfif>
					<cfif len(trim(arguments.distributorNameLike))>
						AND D.DistributorName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.distributorNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.distributorAcctNumLike))>
						AND M.mbrID IN (
												SELECT mbrID
												FROM mbrDistributor WITH(NOLOCK)
												WHERE 1=1
													AND IsActive = 1
													AND DistributorAcctNum LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.distributorAcctNumLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
										)
					</cfif>
					<cfif len(trim(arguments.distributorIDAccess))>
						AND M.DistributorID IN (<cfqueryparam value="#arguments.distributorIDAccess#" CFSQLType="CF_SQL_VARCHAR" list="true">)
					</cfif>
					<cfif len(trim(arguments.distributorTerrIDAccess))>
						AND M.DistributorTerrID IN (<cfqueryparam value="#arguments.distributorTerrIDAccess#" CFSQLType="CF_SQL_VARCHAR" list="true">)
					</cfif>
					<cfif len(trim(arguments.stateAccess))>
						AND M.State IN (<cfqueryparam value="#arguments.stateAccess#" CFSQLType="CF_SQL_VARCHAR" list="true">)
					</cfif>
					<cfif len(trim(arguments.distributorID))>
						AND M.DistributorID = <cfqueryparam value="#arguments.distributorID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif len(trim(arguments.distributorTerrID))>
						AND M.DistributorTerrID = <cfqueryparam value="#arguments.distributorTerrID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif len(trim(arguments.mbrID))>
						AND M.mbrID IN (<cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_VARCHAR" list="true">)
					</cfif>
					<cfif len(trim(arguments.notmbrID))>
						AND M.mbrID <> <cfqueryparam value="#arguments.notmbrID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif len(trim(arguments.isActive))>
						AND M.IsActive = <cfqueryparam value="#arguments.isActive#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.dateCreated))>
						AND M.DTMCreated = <cfqueryparam value="#arguments.dateCreated#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.lastUpdateDTM))>
						AND M.LastUpdateDTM = <cfqueryparam value="#arguments.lastUpdateDTM#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.createUserID))>
						AND M.CreateUserID = <cfqueryparam value="#arguments.createUserID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif len(trim(arguments.lastUpdateUserID))>
						AND M.LastUpdateUserID = <cfqueryparam value="#arguments.lastUpdateUserID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif len(trim(arguments.mbrStatusID))>
						AND M.mbrStatusID = <cfqueryparam value="#arguments.mbrStatusID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif len(trim(arguments.discountTypeID))>
						AND M.DiscountTypeID = <cfqueryparam value="#arguments.discountTypeID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif len(trim(arguments.mbrTierID))>
						AND M.mbrTierID = <cfqueryparam value="#arguments.mbrTierID#" CFSQLType="CF_SQL_INTEGER">
					</cfif>
					<cfif len(trim(arguments.firstName))>
						AND M.FirstName = <cfqueryparam value="#arguments.firstName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.lastName))>
						AND M.LastName = <cfqueryparam value="#arguments.lastName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.email))>
						AND M.EmailAddress = <cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.password))>
						AND dbo.ufn_decrypt(M.Password) = <cfqueryparam value="#arguments.password#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.address1))>
						AND M.Address1 = <cfqueryparam value="#arguments.address1#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.address2))>
						AND M.Address2 = <cfqueryparam value="#arguments.address2#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.city))>
						AND M.City = <cfqueryparam value="#arguments.city#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.state))>
						AND M.State = <cfqueryparam value="#arguments.state#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.zip))>
						AND M.ZipCode = <cfqueryparam value="#arguments.zip#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.country))>
						AND M.Country = <cfqueryparam value="#arguments.country#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.countryAccess))>
		              	AND M.Country IN (<cfqueryparam value="#arguments.countryAccess#" CFSQLType="CF_SQL_VARCHAR" List="true">)
		            </cfif>
					<cfif len(trim(arguments.phone))>
						AND M.Phone = <cfqueryparam value="#arguments.phone#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					</cfif>
					<cfif len(trim(arguments.lastLogin))>
						AND M.LastLogin = <cfqueryparam value="#arguments.lastLogin#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif len(trim(arguments.startDTMCreated))>
						AND M.DTMCreated >= <cfqueryparam value="#arguments.startDTMCreated#" CFSQLType="CF_SQL_DTM">
					</cfif>
					<cfif len(trim(arguments.endDTMCreated))>
						AND M.DTMCreated < <cfqueryparam value="#dateFormat(dateAdd('d', 1, arguments.endDTMCreated), 'mm/dd/yyyy')#" CFSQLType="CF_SQL_DTM">
					</cfif>
					<cfif structKeyExists(ARGUMENTS,"langUID") and  len(trim(arguments.langUID))>
						AND M.langUID = <cfqueryparam value="#arguments.langUID#" CFSQLType="cf_sql_idstamp" />
					</cfif>
					<cfif structKeyExists(ARGUMENTS,"ClientUID") and len(trim(arguments.clientUID))>
						AND M.ClientUID = <cfqueryparam value="#arguments.clientUID#" CFSQLType="cf_sql_idstamp" />
					</cfif>

			)
			SELECT RowNumber, TotalRows, CEILING(TotalRows/CAST(<cfqueryparam value="#arguments.maxRows#" CFSQLType="CF_SQL_INTEGER" /> AS Decimal(10,2))) as TotalPage,
				mbrID,
				IsActive,
				DTMCreated,
				LastUpdateDTM,
				CreateUserID,
				LastUpdateUserID,
				mbrStatusID,
				DiscountTypeID,
				mbrTypeID,
				mbrTierID,
				FirstName,
				LastName,
				EmailAddress,
				Password,
				Address1,
				Address2,
				City,
				State,
				ZipCode,
				Country,
				Phone,
				LastLogin,
				SecurityQuestionID,
				SecurityQuestionAnswer,
				OptOut,
				DistributorID,
				DistributorTerrID,
				Distributor2ID,
				DistributorTerr2ID,
				TermsAcceptanceDTM,
				mbrSalonRelationshipID,
				IsForceProfile,
				OribeAcctNum,
				PhoneFormatted,
				EMOptOutDTM,
				BounceStatus,
				BounceReason,
				ProfileImage,
				Bio,
				Profession,
				GrandfatheredTitanium,
				ParentmbrID,
				mbrStatusName,
				IsAllowLogin,
				IsAllowPointEarning,
				DiscountTypeName,
				Multiplier,
				mbrTypeName,
				ApiKey,
				Question,
				PointBalance,
				RedeemedPoints,
				EarnedPoints,
				ExpiredPoints,
				RedeemedPointsYTD,
				EarnedPointsYTD,
				TierName,
				DistributorName,
				Nickname,
				TerrLabel,
				TerrCode,
				TerrName,
				DistributorNameB,
				NicknameB,
				TerrLabelB,
				TerrCodeB,
				TerrNameB,
				Relationship,
				SalonName,
				businessPhone
				, langUID
				, ClientUID
				, emailConfirmedCanada
				, emailConfirmedDTM
				, optOutCanada
			FROM pagination
			WHERE RowNumber BETWEEN <cfqueryparam value="#startRecord#" CFSQLType="CF_SQL_INTEGER" /> AND <cfqueryparam value="#endRecord#" CFSQLType="CF_SQL_INTEGER" />
			ORDER BY RowNumber
		</cfquery>

		<cfreturn qry>
	</cffunction>

	<cffunction name="editmbr" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">
		<cfargument name="createUserID" type="string" required="no" default="">
		<cfargument name="lastUpdateUserID" type="string" required="no" default="">
		<cfargument name="mbrStatusID" type="string" required="no" default="">
		<cfargument name="discountTypeID" type="string" required="no" default="">
		<cfargument name="mbrTypeID" type="string" required="no" default="">
		<cfargument name="firstName" type="string" required="no" default="">
		<cfargument name="lastName" type="string" required="no" default="">
		<cfargument name="email" type="string" required="no" default="">
		<cfargument name="password" type="string" required="no" default="">
		<cfargument name="address1" type="string" required="no" default="">
		<cfargument name="address2" type="string" required="no" default="">
		<cfargument name="city" type="string" required="no" default="">
		<cfargument name="state" type="string" required="no" default="">
		<cfargument name="zip" type="string" required="no" default="">
		<cfargument name="country" type="string" required="no" default="">
		<cfargument name="phone" type="string" required="no" default="">
		<cfargument name="securityQuestionID" type="string" required="no" default="">
		<cfargument name="securityQuestionAnswer" type="string" required="no" default="">
		<cfargument name="optOut" type="string" required="no" default="">
		<cfargument name="distributorID" type="string" required="no">
		<cfargument name="distributorTerrID" type="string" required="no">
		<cfargument name="distributor2ID" type="string" required="no">
		<cfargument name="distributorTerr2ID" type="string" required="no">
		<cfargument name="mbrSalonRelationshipID" type="string" required="no" default="">
		<cfargument name="mbrTierID" type="string" required="no" default="">
		<cfargument name="oribeAcctNum" type="string" required="no" default="">
		<cfargument name="arrojoAcctNum" type="string" required="no" default="">
		<cfargument name="grandfatheredTitanium" type="string" required="no" default="">
		<cfargument name="langUID" type="guid" required="no" />
		<cfargument name="clientUID" type="guid" required="no" />
		<cfargument name="emailConfirmedCanada" type="boolean" required="false" />
		<cfargument name="emailConfirmedDTM" type="date" required="false" />

		<cfset var qry = "">
		<cfset var mmbrID = "">
		<cfset var mbrRecIsTitanium = false>
		<cfset var isVTSAdmin = false>

		<cfscript>

			if (structKeyExists(arguments, 'clientUID') && len(trim(arguments.clientUID))) {
			    if (trim(arguments.clientUID) == 'C4081D24-579C-4C0D-9EAC-6E2D720CE70E') {

			        /* USA */
			        arguments.country = 'USA';
			        arguments.langUID = 'F2E24085-A7B9-4142-A5E3-38E8DB47B6FA';

			    } else {

			        /* Canada */
			        arguments.country = 'Canada';
			        arguments.langUID = '2878FB41-1408-4A28-BC6D-A1DCF072751C';

			        if (structKeyExists(arguments, 'langUID') && len(trim(arguments.langUID)) && trim(arguments.langUID) == 'FF092976-33E3-425F-B2E8-77B9332103C8') {
			            arguments.langUID = 'FF092976-33E3-425F-B2E8-77B9332103C8';
			        }

			    }
			} else {

			    /* no clientUID: default to US */
			    arguments.clientUID = 'C4081D24-579C-4C0D-9EAC-6E2D720CE70E';
			    arguments.country = 'USA';
			    arguments.langUID = 'F2E24085-A7B9-4142-A5E3-38E8DB47B6FA';
			}

			/* if either the argument.mbrTierID OR the mbrTierID in the DB		*/
			/* is for Titanium then only a vanson admin can insert or update that value */
			local.isTitanium = false; // default
			local.isVTSAdmin = false; // default ( non vanson admin )

			/* get admin security group */
			local.getAdminSecurityLvl = application.cfc.user.getUser(userID = client.userID, clientUID = arguments.clientUID);
			if (local.getAdminSecurityLvl.recordcount && trim(local.getAdminSecurityLvl.userGroup) == 'VTS Admin') {
			    local.isVTSAdmin = true; // is this a vanson admin
			}

			/* mbrTierID they want to change to ( check if it is titanium ) */
			local.newmbrTier = application.cfc.mbrTier.getMbrTier(mbrTierID = arguments.mbrTierID, clientUID = arguments.clientUID);
			if (trim(local.newmbrTier.tierName) == 'Titanium') {
			    local.isTitanium = true;
			}

			/* mbrTierID they are currently assigned in the db ( check if it is titanium ) */
			local.getmbrQry = getmbr(mbrID = val(arguments.mbrID));
			if (local.getmbrQry.recordcount && local.getmbrQry.tierName == 'Titanium') {
			    local.isTitanium = true;
			}

			/* either the mbr is titanium or the update/insert is for titanium */
			if (local.isTitanium && !local.isVTSAdmin) {

			    if (!val(arguments.mbrID)) {
			        // insert: set to the default tier for this client ( silver )
			        local.getDefaultTier = application.cfc.mbrTier.getmbrTier(clientUID = arguments.clientUID, defaultTier = 1);
			        if (local.getDefaultTier.recordcount && local.getDefaultTier.mbrTierID) {
			            arguments.mbrTierID = val(local.getDefaultTier.mbrTierID);
			        }
			    } else {
			        // update: set to their current tier
			        if (local.getmbrQry.recordcount) {
			            arguments.mbrTierID = val(local.getmbrQry.mbrTierID);
			        } else {
			            arguments.mbrTierID = '';
			        }
			    }

			}

			if (!arguments.mbrTierID) {
			    local.getDefaultTier = application.cfc.mbrTier.getmbrTier(clientUID = arguments.clientUID, defaultTier = 1);
			    arguments.mbrTierID = (local.getDefaultTier.recordcount && local.getDefaultTier.mbrTierID) ? val(local.getDefaultTier.mbrTierID) : 1;
			}

		</cfscript>

		<cfif ! val(arguments.mbrID)>

            <cfquery name="qry">
				DECLARE @PasswordHash varchar(256)
						, @PasswordSalt uniqueidentifier

				SET @PasswordSalt = newid()
				SET @PasswordHash = [dbo].[HashWithSalt]('SHA256', <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#"/>, @PasswordSalt)

				INSERT INTO mbr
				(
					CreateUserID,
					LastUpdateUserID,
					mbrStatusID,
					DiscountTypeID,
					mbrTypeID,
					FirstName,
					LastName,
					EmailAddress,
					PasswordHash,
                    PasswordSalt,
					Address1,
					Address2,
					City,
					State,
					ZipCode,
					Country,
					Phone,
					SecurityQuestionID,
					SecurityQuestionAnswer,
					OptOut,
					mbrSalonRelationshipID,
					mbrTierID,
					GrandfatheredTitanium
					<cfif structKeyExists(arguments,"langUID") AND len(trim(arguments.langUID))>
						, langUID
					</cfif>
					<cfif structKeyExists(arguments,"clientUID") AND len(trim(arguments.clientUID))>
						, clientUID
					</cfif>
				)
				VALUES
				(
					<cfqueryparam value="#arguments.createUserID#" CFSQLType="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.lastUpdateUserID#" CFSQLType="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.mbrStatusID#" CFSQLType="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.discountTypeID#" CFSQLType="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.mbrTypeID#" CFSQLType="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.firstName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					<cfqueryparam value="#arguments.lastName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					<cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					@PasswordHash, @PasswordSalt,
					<cfqueryparam value="#arguments.address1#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					<cfqueryparam value="#arguments.address2#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					<cfqueryparam value="#arguments.city#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					<cfqueryparam value="#arguments.state#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					<cfqueryparam value="#arguments.zip#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					<cfqueryparam value="#arguments.country#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					<cfqueryparam value="#arguments.phone#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					<cfqueryparam value="#arguments.securityQuestionID#" CFSQLType="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.securityQuestionAnswer#" CFSQLType="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.optOut#" CFSQLType="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.mbrSalonRelationshipID#" CFSQLType="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.mbrTierID#" CFSQLType="CF_SQL_VARCHAR">,
					<cfqueryparam value="#arguments.grandfatheredTitanium#" CFSQLType="CF_SQL_VARCHAR">
					<cfif structKeyExists(arguments,"langUID") AND len(trim(arguments.langUID))>
						, <cfqueryparam value="#arguments.langUID#" CFSQLType="cf_sql_idstamp" />
					</cfif>
					<cfif structKeyExists(arguments,"clientUID") AND len(trim(arguments.clientUID))>
						, <cfqueryparam value="#arguments.clientUID#" CFSQLType="cf_sql_idstamp" />
					</cfif>
				)

				SELECT Scope_IDentity() AS mbrID
			</cfquery>

			<cfset mmbrID = qry.mbrID>

		<cfelse>

			<cfquery name="qry">
				UPDATE mbr
				SET  LastUpdateUserID = <cfqueryparam value="#arguments.lastUpdateUserID#" CFSQLType="CF_SQL_INTEGER">
					,mbrStatusID = <cfqueryparam value="#arguments.mbrStatusID#" CFSQLType="CF_SQL_INTEGER">
					,DiscountTypeID = <cfqueryparam value="#arguments.discountTypeID#" CFSQLType="CF_SQL_INTEGER">
					,mbrTypeID = <cfqueryparam value="#arguments.mbrTypeID#" CFSQLType="CF_SQL_INTEGER">
					,FirstName = <cfqueryparam value="#arguments.firstName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					,LastName = <cfqueryparam value="#arguments.lastName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
                    ,EmailAddress = <cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
                    <cfif len(arguments.password)>
					    ,PasswordHash = dbo.HashWithSalt('SHA256',<cfqueryparam value="#arguments.password#" CFSQLType="cf_sql_varchar" />,passwordSalt)
                    </cfif>
					,Address1 = <cfqueryparam value="#arguments.address1#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					,Address2 = <cfqueryparam value="#arguments.address2#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					,City = <cfqueryparam value="#arguments.city#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					,State = <cfqueryparam value="#arguments.state#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					,ZipCode = <cfqueryparam value="#arguments.zip#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					,Country = <cfqueryparam value="#arguments.country#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					,Phone = <cfqueryparam value="#arguments.phone#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
					,SecurityQuestionID = <cfqueryparam value="#arguments.securityQuestionID#" CFSQLType="CF_SQL_VARCHAR">
					,SecurityQuestionAnswer = <cfqueryparam value="#arguments.securityQuestionAnswer#" CFSQLType="CF_SQL_VARCHAR">
					,OptOut = <cfqueryparam value="#arguments.optOut#" CFSQLType="CF_SQL_VARCHAR">

					<cfif structKeyExists(arguments,"DistributorID") AND len(trim(arguments.distributorID))>
						,DistributorID = <cfqueryparam value="#arguments.distributorID#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif structKeyExists(arguments,"DistributorTerrID") AND len(trim(arguments.distributorTerrID))>
						,DistributorTerrID = <cfqueryparam value="#arguments.distributorTerrID#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif structKeyExists(arguments,"Distributor2ID") AND len(trim(arguments.distributor2ID))>
						,Distributor2ID = <cfqueryparam value="#arguments.distributor2ID#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>
					<cfif structKeyExists(arguments,"DistributorTerr2ID") AND len(trim(arguments.distributorTerr2ID))>
						,DistributorTerr2ID = <cfqueryparam value="#arguments.distributorTerr2ID#" CFSQLType="CF_SQL_VARCHAR">
					</cfif>

					<cfif arguments.optOut EQ 0>
						,EMOptOutDTM = NULL
		                ,BounceStatus = NULL
		                ,BounceReason = NULL
					<cfelse>
						,EMOptOutDTM = getdate()
					</cfif>
					,mbrSalonRelationshipID = <cfqueryparam value="#arguments.mbrSalonRelationshipID#" CFSQLType="CF_SQL_VARCHAR">
					,GrandfatheredTitanium = <cfqueryparam value="#arguments.grandfatheredTitanium#" CFSQLType="CF_SQL_VARCHAR">
					,LastUpdateDTM = getdate()
					<cfif structKeyExists(arguments,"langUID") AND len(trim(arguments.langUID))>
						, langUID = <cfqueryparam value="#arguments.langUID#" CFSQLType="cf_sql_idstamp" />
					</cfif>
					<cfif structKeyExists(arguments,"clientUID") AND len(trim(arguments.clientUID))>
						, clientUID = <cfqueryparam value="#arguments.clientUID#" CFSQLType="cf_sql_idstamp" />
					</cfif>
					<cfif len(trim(arguments.mbrTierID))>
						, mbrTierID = <cfqueryparam value="#arguments.mbrTierID#" CFSQLType="CF_SQL_VARCHAR" />
					</cfif>
				WHERE mbrID = <cfqueryparam value="#val(arguments.mbrID)#" CFSQLType="CF_SQL_INTEGER">
			</cfquery>

			<cfset mmbrID = arguments.mbrID>

		</cfif>

		<!--- Incorrect Distributor - send email to: Jennifer.Zichelli@kao.com (in systemConfig table) --->
		<cfif arguments.mbrStatusID EQ 4>

			<!--- Get SystemConfig Email --->
			<cfset var qryEmailAddress = application.cfc.systemConfig.getSystemConfig(SystemConfigName="mbr Status Email",clientUID=request.siteobj.clientUID) />

			<cfif qryEmailAddress.recordCount AND IsValid("email", qryEmailAddress.systemConfigValue)>

				<cfset var mEmailAddr = qryEmailAddress.systemConfigValue>

				<cfswitch expression="#application.environment#">
					<cfcase value="dev">
						<cfset mEmailAddr = "jason.prieve@vansontech.com">
					</cfcase>
					<cfcase value="qa">
						<cfset mEmailAddr = "jason.prieve@vansontech.com">
					</cfcase>
				</cfswitch>

				<!--- email subject / body --->
				<cfset var mEmailSubject 	= "Incorrect Distributor Assignment please review">
				<cfset var mEmailBody 		= "#mEmailSubject#.">

				<!--- Send the Email --->
				<cfmail to="#mEmailAddr#" from="#application.programEmail#" subject="#mEmailSubject#" type="html">
					#mEmailBody#
				</cfmail>

				<!--- Log the email --->
				<cfset var tmpEmailLog = application.cfc.emailLog.editEmailLog(
							EmailLogID="0",
							CreateUserID="-1",
							LastUpdateUserID="-1",
							mbrID="#arguments.mbrID#",
							XRefID="0",
							EmailTypeID="6",
							SentDTM="#NOW()#",
							EmailAddress="#mEmailAddr#",
							EmailHtml="#mEmailBody#"
						) />

			</cfif>
		</cfif>

		<cfif arguments.mbrStatusID EQ 8>

		</cfif>



		<cfreturn mmbrID>
	</cffunction>

	<cffunction name="editmbrProfile" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">
		<cfargument name="lastUpdateUserID" type="string" required="no" default="">
		<cfargument name="firstName" type="string" required="no" default="">
		<cfargument name="lastName" type="string" required="no" default="">
		<cfargument name="email" type="string" required="no" default="">
		<cfargument name="password" type="string" required="no" default="">
		<cfargument name="phone" type="string" required="no" default="">
		<cfargument name="securityQuestionID" type="string" required="no" default="">
		<cfargument name="securityQuestionAnswer" type="string" required="no" default="">
		<cfargument name="optOut" type="string" required="no" default="">
		<cfargument name="distributorID" type="string" required="no" default="">
		<cfargument name="mbrSalonRelationshipID" type="string" required="no" default="">
		<cfargument name="profileImage" type="string" required="no" default="">
		<cfargument name="bio" type="string" required="no" default="">
		<cfargument name="profession" type="string" required="no" default="">
		<cfargument name="langUID" required="no" />
		<cfargument name="emailConfirmedCanada" type="boolean" required="false" />
		<cfargument name="emailConfirmedDTM" type="date" required="false" />

		<cfset var qry = "">
		<cfset var mmbrID = "">
		<cfset arguments.phone = reReplaceNoCase(arguments.phone,'[^0-9]','','all')>

		<cfquery name="qry">
			UPDATE mbr
			SET LastUpdateUserID = <cfqueryparam value="#arguments.lastUpdateUserID#" CFSQLType="CF_SQL_INTEGER">,
				FirstName = <cfqueryparam value="#arguments.firstName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
				LastName = <cfqueryparam value="#arguments.lastName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
				EmailAddress = <cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
				PasswordHash = dbo.HashWithSalt('SHA256',<cfqueryparam value="#arguments.password#" CFSQLType="cf_sql_varchar" />,passwordSalt),
				Phone = <cfqueryparam value="#arguments.phone#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
				SecurityQuestionID = <cfqueryparam value="#arguments.securityQuestionID#" CFSQLType="CF_SQL_VARCHAR">,
				SecurityQuestionAnswer = <cfqueryparam value="#arguments.securityQuestionAnswer#" CFSQLType="CF_SQL_VARCHAR">,
				<cfif arguments.optOut EQ 0>
				EMOptOutDTM = NULL,
                BounceStatus = NULL,
                BounceReason = NULL,
				<cfelse>
				EMOptOutDTM = getdate(),
				</cfif>
				OptOut = <cfqueryparam value="#arguments.optOut#" CFSQLType="CF_SQL_VARCHAR">,

				<cfif structKeyExists(arguments,'DistributorID') AND val(arguments.distributorID)>
					DistributorID = <cfqueryparam value="#arguments.distributorID#" CFSQLType="CF_SQL_VARCHAR">,
				</cfif>

				mbrSalonRelationshipID = <cfqueryparam value="#arguments.mbrSalonRelationshipID#" CFSQLType="CF_SQL_VARCHAR">,
				ProfileImage = <cfqueryparam value="#arguments.profileImage#" CFSQLType="CF_SQL_VARCHAR">,
				Bio = <cfqueryparam value="#arguments.bio#" CFSQLType="CF_SQL_VARCHAR">,
				Profession = <cfqueryparam value="#arguments.profession#" CFSQLType="CF_SQL_VARCHAR">,
				LastUpdateDTM = getdate()
				<cfif structKeyExists(arguments,"langUID") AND len(trim(arguments.langUID))>
					, langUID = <cfqueryparam value="#arguments.langUID#" CFSQLType="cf_sql_idstamp" />
				</cfif>
			WHERE mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
		</cfquery>

		<cfset mmbrID = arguments.mbrID>

		<cfreturn mmbrID>
	</cffunction>

	<cffunction name="editmbrRegisterStepOne" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">
		<cfargument name="firstName" type="string" required="no" default="">
		<cfargument name="lastName" type="string" required="no" default="">
		<cfargument name="email" type="string" required="no" default="">
		<cfargument name="country" type="string" required="no" default="">
		<cfargument name="password" type="string" required="no" default="">
		<cfargument name="phone" type="string" required="no" default="">
		<cfargument name="securityQuestionID" type="string" required="no" default="">
		<cfargument name="securityQuestionAnswer" type="string" required="no" default="">
		<cfargument name="optOut" type="string" required="no" default="">
		<cfargument name="mbrSalonRelationshipID" type="string" required="no" default="">
		<cfargument name="langUID" required="no" />
		<cfargument name="clientUID" required="no" />

		<cfif structKeyExists(arguments,"clientUID")>
			<!--- if usa then set lang to english --->
			<cfif arguments.clientUID EQ "C4081D24-579C-4C0D-9EAC-6E2D720CE70E">
				<cfset arguments.langUID = "F2E24085-A7B9-4142-A5E3-38E8DB47B6FA" />
			</cfif>
		</cfif>

		<cfif structKeyExists(arguments,"country")>
			<!--- if usa then set lang to english --->
			<cfif arguments.country EQ "USA" OR arguments.country EQ "US">
				<cfset arguments.langUID = "F2E24085-A7B9-4142-A5E3-38E8DB47B6FA" />
			</cfif>
		</cfif>

		<cfset var qry = "">
		<cfset var mmbrID = "">
		<cfset arguments.phone = reReplaceNoCase(arguments.phone,'[^0-9]','','all')>

		<cfif arguments.mbrID EQ 0>
            <cfquery name="qry">
				DECLARE @PasswordHash varchar(256)
						, @PasswordSalt uniqueidentifier

				SET @PasswordSalt = newid()
				SET @PasswordHash = [dbo].[HashWithSalt]('SHA256', <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#"/>, @PasswordSalt)

				INSERT INTO mbr
				(
					IsActive,
					CreateUserID,
					LastUpdateUserID,
					mbrStatusID,
					DiscountTypeID,
					FirstName,
					LastName,
					country,
					EmailAddress,
					PasswordHash,
                    PasswordSalt,
					Phone,
					SecurityQuestionID,
					SecurityQuestionAnswer,
					OptOut,
					mbrSalonRelationshipID
					<cfif structKeyExists(arguments,"langUID") AND len(trim(arguments.langUID))>
						, langUID
					</cfif>
					<cfif structKeyExists(arguments,"ClientUID") AND len(trim(arguments.clientUID))>
						, ClientUID
					</cfif>
				)
				VALUES (
							1,
							-1,
							-1,
							6,
							1,
							<cfqueryparam value="#arguments.firstName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
							<cfqueryparam value="#arguments.lastName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
							<cfqueryparam value="#arguments.country#" CFSQLType="CF_SQL_VARCHAR" maxlength="50">,
							<cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
							@PasswordHash, @PasswordSalt,
							<cfqueryparam value="#arguments.phone#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
							<cfqueryparam value="#arguments.securityQuestionID#" CFSQLType="CF_SQL_VARCHAR">,
							<cfqueryparam value="#arguments.securityQuestionAnswer#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
							<cfqueryparam value="#arguments.optOut#" CFSQLType="CF_SQL_VARCHAR">,
							<cfqueryparam value="#arguments.mbrSalonRelationshipID#" CFSQLType="CF_SQL_VARCHAR">
							<cfif structKeyExists(arguments,"langUID") AND len(trim(arguments.langUID))>
								,<cfqueryparam value="#arguments.langUID#" CFSQLType="cf_sql_idstamp" />
							</cfif>
							<cfif structKeyExists(arguments,"ClientUID") AND len(trim(arguments.clientUID))>
								,<cfqueryparam value="#arguments.clientUID#" CFSQLType="cf_sql_idstamp" />
							</cfif>
						)

				SELECT Scope_IDentity() AS mbrID

			</cfquery>
			<cfset mmbrID = qry.mbrID>
		<cfelse>
			<cfquery name="qry">
				UPDATE mbr
				SET LastUpdateUserID = -1,
					FirstName = <cfqueryparam value="#arguments.firstName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					LastName = <cfqueryparam value="#arguments.lastName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					country = <cfqueryparam value="#arguments.country#" CFSQLType="CF_SQL_VARCHAR" maxlength="50">,
					EmailAddress = <cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					Password = dbo.ufn_encrypt(<cfqueryparam value="#arguments.password#" CFSQLType="cf_sql_varchar" />),
					Phone = <cfqueryparam value="#arguments.phone#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					SecurityQuestionID = <cfqueryparam value="#arguments.securityQuestionID#" CFSQLType="CF_SQL_VARCHAR">,
					SecurityQuestionAnswer = <cfqueryparam value="#arguments.securityQuestionAnswer#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
					mbrSalonRelationshipID = <cfqueryparam value="#arguments.mbrSalonRelationshipID#" CFSQLType="CF_SQL_VARCHAR">,
					OptOut = <cfqueryparam value="#arguments.optOut#" CFSQLType="CF_SQL_VARCHAR">,
					LastUpdateDTM = getdate()
					<cfif structKeyExists(arguments,"langUID") AND len(trim(arguments.langUID))>
						, langUID = <cfqueryparam value="#arguments.langUID#" CFSQLType="cf_sql_idstamp" />
					</cfif>
					<cfif structKeyExists(arguments,"ClientUID") AND len(trim(arguments.clientUID))>
						, clientUID = <cfqueryparam value="#arguments.clientUID#" CFSQLType="cf_sql_idstamp" />
					</cfif>
				WHERE mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
			</cfquery>
			<cfset mmbrID = arguments.mbrID>
		</cfif>

		<cfreturn mmbrID>
	</cffunction>

	<cffunction name="editmbrRegisterStepTwo" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">
		<cfargument name="state" type="string" required="no" default="">

		<cfset var qry = "">
		<cfset var mmbrID = "">

		<cfquery name="qry">
			UPDATE mbr
			SET State = <cfqueryparam value="#arguments.state#" CFSQLType="CF_SQL_VARCHAR">,
				LastUpdateDTM = getdate()
			WHERE mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
		</cfquery>

		<cfset mmbrID = arguments.mbrID>

		<cfreturn mmbrID>
	</cffunction>

	<cffunction name="editmbrRegisterStepThree" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">
		<cfargument name="distributorID" type="string" required="yes">

		<cfset var qry = "">
		<cfset var mmbrID = "">

		<cfquery name="qry">
			UPDATE mbr
			SET LastUpdateUserID = -1
				,LastUpdateDTM = getdate()
				<cfif structKeyExists(ARGUMENTS,'DistributorID') AND val(arguments.distributorID)>
					,DistributorID = <cfqueryparam value="#arguments.distributorID#" CFSQLType="CF_SQL_INTEGER">
				</cfif>
			WHERE mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
		</cfquery>

		<cfset mmbrID = arguments.mbrID>

		<cfreturn mmbrID>
	</cffunction>

	<cffunction name="editmbrRegisterCompleted" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">

		<cfset var qry = "">
		<cfset var mmbrID = "">

		<cfquery name="qry">
			UPDATE mbr
			SET LastUpdateUserID = -1,
				IsActive = 1,
				mbrStatusID = 3,
				TermsAcceptanceDTM = getdate(),
				LastUpdateDTM = getdate()
			WHERE mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
		</cfquery>

		<cfset mmbrID = arguments.mbrID>

		<cfreturn mmbrID>
	</cffunction>

	<cffunction name="deletembr" access="public" returntype="boolean">
		<cfargument name="mbrID" type="string" required="yes" default="0">
		<cfargument name="lastUpdateUserID" type="string" required="no" default="0">
		<cfset var qry = "">

		<cfquery name="qry">
			UPDATE mbr
			SET IsActive = 0,
				LastUpdateUserID = <cfqueryparam value="#arguments.lastUpdateUserID#" CFSQLType="CF_SQL_INTEGER">,
				LastUpdateDTM = getdate()
			WHERE mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
		</cfquery>

		<cfreturn 1>
	</cffunction>

	<cffunction name="checkmbrLogin" access="public" returntype="string">
        <cfargument name="clientUID" type="string" required="yes" default="">
		<cfargument name="email" type="string" required="yes" default="">
		<cfargument name="password" type="string" required="yes" default="">
		<!--- <cfargument name="ClientID" required="yes" default=""> --->

		<cfset var qry = "">
        <cfset var mReturnString = "">
        <cfset var qryValidatePassword = "">

		<!--- Check the Credentials --->
		<cfquery name="qry">
			SELECT M.mbrID, PasswordSalt, PasswordHash
			FROM mbr M WITH(NOLOCK)
				INNER JOIN mbrStatus MS WITH(NOLOCK) ON M.mbrStatusID = MS.mbrStatusID
			WHERE 1=1
				AND M.IsActive = 1
				AND MS.IsAllowLogin = 1
				AND M.EmailAddress = <cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" />
                AND M.clientUID = <cfqueryparam value="#arguments.clientUID#" CFSQLType="CF_SQL_idstamp" />
		</cfquery>

		<cfif NOT qry.recordCount>
			<cfset mReturnString = "We're sorry, that email address was not found.">
		<cfelseif qry.recordCount>
            <cfquery name="qryValidatePassword">
                SELECT m.mbrID
                FROM mbr m with (nolock)
                INNER JOIN mbrStatus MS WITH(NOLOCK) ON M.mbrStatusID = MS.mbrStatusID
                WHERE 1=1
                    AND M.PasswordHash = dbo.HashWithSalt('SHA256',<cfqueryparam value="#arguments.password#" CFSQLType="cf_sql_varchar" />, m.passwordsalt)
                    AND M.IsActive = 1
                    AND MS.IsAllowLogin = 1
                    AND M.EmailAddress = <cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" />
                    AND M.clientUID = <cfqueryparam value="#arguments.clientUID#" CFSQLType="CF_SQL_idstamp" />
            </cfquery>

            <cfif not qryValidatePassword.recordCount>
			    <cfset mReturnString = "We're sorry, that is not the correct password for the email address that was entered.">
		    <cfelse>
                <!--- Log the login --->
                <cfset var login = application.cfc.mbrLogin.editmbrLogin(
                                                                            mbrLoginID="0",
                                                                            CreateUserID="-1",
                                                                            LastUpdateUserID="-1",
                                                                            mbrID="#qryValidatePassword.mbrID#"
                                                                        ) />

                <!--- Update the LastLogin on the mbr record --->
                <cfquery>
                    UPDATE mbr
                    SET LastLogin = getdate()
                    WHERE mbrID = <cfqueryparam value="#qry.mbrID#" CFSQLType="CF_SQL_VARCHAR" />
                </cfquery>

                <cfset mReturnString = qry.mbrID>
            </cfif>
        </cfif>

		<cfreturn mReturnString>

	</cffunction>

	<cffunction name="mbrLogout"  access="public" returntype="any">
		<cfset var cVars = "">
		<cfset var i = "">
		<cfset var x = "">
		<cfset var Y = "">

		<cfset cVars = GetClientVariablesList()>

		<cfloop From="#ListLen(cVars)#" To="1" INDEX="i" STEP="-1">
			<cfset x = ListGetAt(cVars,i)>
			<cfif listFindNoCase("CartID,mbrID,ApiKey,mbrTimeout,ImpersonateUserID", X)>
				<cfset Y=DeleteClientVariable("#X#")>
			</cfif>
		</cfloop>

		<cfif isDefined("cookie.prsCookie")>
			<cfset local.cookieValues = deserializeJson(cookie.prsCookie) />
			<cfset local.cookieValues.KEYWORDS 	= "" />
			<cfcookie name="prsCookie" value="#serializeJSON(local.cookieValues)#">
		</cfif>

		<cfscript>

			structDelete(session,'mbr',true);
			structDelete(session,'mbrid',true);

		</cfscript>

	</cffunction>

	<cffunction name="editmbrTermsAcceptanceDTM" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">
		<cfargument name="optOutCanada" type="boolean" required="no">

		<cfset var qry = "">
		<cfset var mmbrID = "">

		<cfquery name="qry">
			UPDATE mbr
			SET LastUpdateUserID = -1,
				TermsAcceptanceDTM = getdate(),
				LastUpdateDTM = getdate()
				<cfif structKeyExists(arguments,'optOutCanada') AND len(trim(arguments.optOutCanada))>
					, optOutCanada =  <cfqueryparam value="#arguments.optOutCanada#" CFSQLType="CF_SQL_bit">
					, optOut       =  <cfqueryparam value="#arguments.optOutCanada#" CFSQLType="CF_SQL_bit">
				</cfif>
			WHERE mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
		</cfquery>

		<cfset mmbrID = arguments.mbrID>

		<cfreturn mmbrID>
	</cffunction>

	<cffunction name="editmbrIsForceProfile" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">

		<cfset var qry = "">
		<cfset var mmbrID = "">

		<cfquery name="qry">
			UPDATE mbr
			SET LastUpdateUserID = -1,
				IsForceProfile = 0,
				LastUpdateDTM = getdate()
			WHERE mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
		</cfquery>

		<cfset mmbrID = arguments.mbrID>

		<cfreturn mmbrID>
	</cffunction>

	<cffunction name="editmbrPassword" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">
		<cfargument name="password" type="string" required="yes" default="">

		<cfset var qry = "">
		<cfset var mmbrID = "">

		<cfquery name="qry">
			UPDATE mbr
			SET LastUpdateUserID = -1,
                PasswordHash = dbo.HashWithSalt('SHA256',<cfqueryparam value="#arguments.password#" CFSQLType="cf_sql_varchar" />,passwordSalt),
				LastUpdateDTM = getdate()
			WHERE mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
		</cfquery>

		<cfset mmbrID = arguments.mbrID>

		<cfreturn mmbrID>
	</cffunction>

	<cffunction name="getmbrJSON" returntype="array" access="remote" output="no" returnformat="JSON">
		<cfargument name="notmbrID" type="string" required="no" default="" />
		<cfargument name="email" type="string" required="no" default="" />

		<cfset var qry = "">

		<cfset qry = this.Getmbr(NotmbrID="#arguments.notmbrID#",EmailAddress="#arguments.email#",maxrows="1") />

		<cfset qry = application.cfc.misc.queryToArray(qry) />

		<cfreturn qry />
	</cffunction>

	<cffunction name="getmbrCount" returntype="boolean" access="public">
		<cfargument name="distributorIDAccess" type="string" default="" />
		<cfargument name="distributorTerrIDAccess" type="string" default="" />
		<cfargument name="stateAccess" type="string" required="no" default="" />
		<cfargument name="mbrStatusID" type="string" required="no" default="" />
		<cfargument name="termsAccepted" type="string" required="no" default="" />
		<cfargument name="langUID" required="no" default="" />
		<cfargument name="clientUID" required="no" default="" />
		<cfargument name="emailConfirmedCanada" type="boolean" required="false" />
		<cfargument name="emailConfirmedDTM" type="date" required="false" />

		<cfset var qPendingmbr = "" />

		<cfquery name="qPendingmbr">
			SELECT COUNT(M.mbrID) cnt
			FROM mbr M WITH(NOLOCK)
			WHERE 1=1
				AND M.IsActive = 1
				<cfif arguments.termsAccepted EQ 1>
					AND IsNull(M.TermsAcceptanceDTM, '1/1/1900') > '1/1/1900'
				<CFELSEIF arguments.termsAccepted EQ 0>
					AND IsNull(M.TermsAcceptanceDTM, '1/1/1900') = '1/1/1900'
				</cfif>
				<cfif len(trim(arguments.mbrStatusID))>
					AND M.mbrStatusID IN (<cfqueryparam value="#arguments.mbrStatusID#" CFSQLType="CF_SQL_VARCHAR" list="true">)
				</cfif>
				<cfif len(trim(arguments.distributorIDAccess))>
					AND M.DistributorID IN (<cfqueryparam value="#arguments.distributorIDAccess#" CFSQLType="CF_SQL_VARCHAR" list="true">)
				</cfif>
				<cfif len(trim(arguments.distributorTerrIDAccess))>
					AND M.DistributorTerrID IN (<cfqueryparam value="#arguments.distributorTerrIDAccess#" CFSQLType="CF_SQL_VARCHAR" list="true">)
				</cfif>
				<cfif len(trim(arguments.stateAccess))>
					AND M.State IN (<cfqueryparam value="#arguments.stateAccess#" CFSQLType="CF_SQL_VARCHAR" list="true">)
				</cfif>

				<cfif len(trim(arguments.langUID))>
					and langUID = <cfqueryparam value="#arguments.langUID#" CFSQLType="cf_sql_idstamp" />
				</cfif>
				<cfif len(trim(arguments.clientUID))>
					and clientUID = <cfqueryparam value="#arguments.clientUID#" CFSQLType="cf_sql_idstamp" />
				</cfif>


		</cfquery>

		<cfreturn qPendingmbr.cnt>

	</cffunction>

	<cffunction name="getDistributorDiscrepancy" returntype="any" access="public">
		<cfargument name="distributorID" type="string" default="" />
		<cfset var local = {} />
		<cfquery name="local.qry">
			declare @distributorID int
			set @distributorID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#arguments.distributorID#" null="#!isNumeric(arguments.distributorID)#">

			select  COUNT(*) OVER () as Total_Rows
				,m.FirstName
				,m.LastName
				,m.mbrID
				,m.DistributorID mbrDistributorID
				,dt.distributorID territoryDistributorID
				,dt.DistributorTerrID
				,md.distributorName mbrDistributorName
				,td.DistributorName TerrDistributorName
			from mbr m
				left join DistributorTerr dt on m.DistributorTerrID = dt.DistributorTerrID and dt.isActive = 1
				left join distributor md on m.distributorID = md.distributorID
				left join Distributor td on dt.DistributorID = td.DistributorID
			where m.isActive =1
			<cfif arguments.distributorID EQ 0>
				and (m.distributorID is NULL)
			<cfelse>
				and (m.distributorID = @distributorID or @distributorID is null )
				and (m.distributorID != dt.distributorID or m.distributorTerrID is null or m.distributorID is null)
			</cfif>
		</cfquery>

		<cfreturn local.qry>

	</cffunction>

	<cffunction name="getmbrExpiringPoints" returntype="query" access="public">
		<cfargument name="mbrID" type="string" default="" />

		<cfset var qryExpiringPoints = "" />

		<cfquery name="qryExpiringPoints">
            DECLARE @StartDTM DATETIME,
                @EndDTM DATETIME,
                @mbrID INT

            SET @StartDTM = Convert(DTMTime, DATEDIFF(DAY, 0, GETDATE())) -- FLOOR TO MidNight
            SET @StartDTM = DATEADD(DAY, (DAY(@StartDTM)*-1+1), @StartDTM) -- MOVE TO THE FIRST OF THIS MONTH
            SET @EndDTM = DATEADD(MONTH, 1, @StartDTM) -- FIRST OF NEXT MONTH AT MIDNIGHT
            SET @mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER" />

			SELECT TOP 1 IsNull(SUM(M.Points-M.PointsRedeemed), 0) AS ExpiringPoints, Min(M.ExpirationDTM) as ExpirationDTM
			FROM mbrTransaction M WITH(NOLOCK)
			WHERE 1=1
				AND M.IsActive=1
				AND M.mbrID = @mbrID
				AND IsNull(M.ExpirationDTM, '1/1/1900')  > @StartDTM
				AND IsNull(M.ExpirationDTM, '1/1/1900')  <= @EndDTM
				AND M.ExpiredPoints = 0
				AND M.Points-M.PointsRedeemed > 0
            ORDER BY ExpirationDTM
		</cfquery>

		<cfreturn qryExpiringPoints>

	</cffunction>

	<cffunction name="editmbrStylist" access="public" returntype="numeric">
		<cfargument name="mbrID" type="string" required="yes" default="0">
		<cfargument name="parentmbrID" type="string" required="yes" default="0">
		<cfargument name="firstName" type="string" required="no" default="">
		<cfargument name="lastName" type="string" required="no" default="">
		<cfargument name="email" type="string" required="no" default="">

		<cfset var qry = "">
		<cfset var mmbrID = "">

		<cfif arguments.mbrID EQ 0>
			<cfquery name="qry">
				INSERT INTO mbr (
										CreateUserID,
										LastUpdateUserID,
										mbrStatusID,
										mbrTypeID,
										FirstName,
										LastName,
										EmailAddress,
										ParentmbrID,
										IsForceProfile,
										DiscountTypeID
									)
				VALUES (
							-82,
							-82,
							1,
							4,
							<cfqueryparam value="#arguments.firstName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
							<cfqueryparam value="#arguments.lastName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
							<cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
							<cfqueryparam value="#arguments.parentmbrID#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">,
							1,
							1
						)

				SELECT Scope_IDentity() AS mbrID
			</cfquery>

			<cfset mmbrID = qry.mbrID>

		</cfif>

		<cfreturn mmbrID>

	</cffunction>

	<cffunction name="getmbrsByTemplate" access="public" returntype="query">
		<cfargument name="template" type="string" required="no" default=""hint="Filters list by ">
		<cfargument name="clientUID" required="no" hint="Determines country code">
		<cfset var qry = "">
		<!--- <cfset var template = ""> --->

		<cfquery name="qry">
			select m.mbrID, m.FirstName, m.LastName
			from mbr m WITH(NOLOCK)
			where m.IsActive = 1
				<cfif structKeyExists(ARGUMENTS,"ClientUID") and len(trim(arguments.clientUID))>
					AND M.ClientUID = <cfqueryparam value="#arguments.clientUID#" CFSQLType="cf_sql_idstamp" />
				</cfif>
				<cfif arguments.template EQ "/email/ContactUsAdmin.cfm">
					AND EXISTS (SELECT ContactUsID FROM ContactUs c WHERE c.mbrID = m.mbrID AND c.IsActive = 1)
				</cfif>
				<cfif arguments.template EQ "/email/IDeaExchangeAdmin.cfm">
					AND EXISTS (SELECT ideaExchangeID FROM ideaExchange ie WHERE ie.mbrID = m.mbrID AND ie.IsActive = 1)
				</cfif>
				<cfif arguments.template EQ "/email/IDeaExchangeCommentAdmin.cfm">
					AND EXISTS (SELECT ideaExchangeCommentID FROM ideaExchangeComment iec WHERE iec.mbrID = m.mbrID AND iec.IsActive = 1)
				</cfif>
				<cfif arguments.template EQ "/email/OrderConfirmation.cfm">
					AND EXISTS (SELECT orderID FROM [order] o WHERE o.mbrID = m.mbrID AND o.IsActive = 1)
				</cfif>
			group by m.mbrID, m.FirstName, m.LastName
			order by m.FirstName, m.LastName
		</cfquery>

		<cfreturn qry>

	</cffunction>

	<cffunction name="getmbrDistributionList" access="public" returntype="query" hint="This function gets a list of mbrs and their related salons">
		<cfargument name="mbrID" type="numeric" required="true" default="0" hint="For use with a single mbr.">
		<cfargument name="maxRows" type="numeric" required="true" default="500" hint="The number of rows to return.">
		<cfargument name="pageNumber" type="numeric" required="true" default="1" hint="The number of rows to return.">
		<cfargument name="clientUID" type="string" required="true" default="" hint="Determines country code.">
		<cfargument name="tierID" type="numeric" required="true" default="0" hint="Filter for Tier.">
		<cfargument name="orderBy" type="string" required="false" default="M.FirstName, M.LastName" hint="Specifies order of returned results.">
		<cfargument name="excel" type="numeric" required="false" default="0" hint="The number of rows to return.">

		<cfset var startRecord = ((arguments.pageNumber-1)*arguments.maxRows)+1 />
		<cfset var endRecord = (arguments.pageNumber*arguments.maxRows) />

		<cfscript>
			var qry = "";
			var startRecord = ((arguments.pageNumber-1) * arguments.maxRows) + 1;
			var endRecord = (arguments.pageNumber * arguments.maxRows);

			// get all the records if this is an excel request
			if(arguments.excel){
				startRecord = 1;
				endRecord = arguments.maxRows;
			}
		</cfscript>

		<cfquery name="qry">
			SELECT
				#arguments.maxRows# as row_max,
				RowNumber,
				TotalRows,
				CEILING(TotalRows/CAST(<cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#arguments.maxRows#"> AS Decimal(10,2))) as TotalPage,
				mbrID,
				FirstName,
				LastName,
				EmailAddress,
				LastLogin,
				Country,
				Phone,
				DTMCreated,
				mbrStatusName,
				DiscountTypeName,
				PointBalance,
				RedeemedPointsYTD,
				EarnedPointsYTD,
				TierName,
				Nickname,
				MultipleSalons,
				MasterSalon,
				mbrSalonID,
				SalonName,
				SalonAddress1,
				SalonAddress2,
				SalonCity,
				SalonState,
				SalonCountry,
				SalonPhone,
				SalonFinderID,
				TerrLabel,
				TerrCode,
				mbrTypeName,
				GrandfatheredTitanium
			FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY <cfqueryparam CFSQLType="cf_sql_varchar" value="#arguments.orderBy#">) AS RowNumber, Count(*) OVER() AS TotalRows,
					M.mbrID,
					M.FirstName,
					M.LastName,
					M.EmailAddress,
					M.LastLogin,
					M.Address1,
					M.Address2,
					M.City,
					M.State,
					M.ZipCode,
					M.Country,
					M.Phone,
					M.DTMCreated,
					MS.mbrStatusName,
					DTY.DiscountTypeName,
					IsNull(VMTS.PointBalance, 0) AS PointBalance,
					IsNull(VMTS.RedeemedPointsYTD, 0) AS RedeemedPointsYTD,
					IsNull(VMTS.EarnedPointsYTD, 0) AS EarnedPointsYTD,
					MTI.TierName,
					D.Nickname,
					case
						when
							(select count(mbrSalonID) from dbo.mbrSalon where mbrID = M.mbrID and IsActive = 1) > 1
							then 1
						else
							0
					end as MultipleSalons,
					case when isnull(MSAL.IsMaster,0) = 1 then 'Yes' else 'No' end as MasterSalon,
					MSAL.mbrSalonID,
					MSAL.SalonName,
					MSAL.Address1 AS SalonAddress1,
					MSAL.Address2 AS SalonAddress2,
					MSAL.City AS SalonCity,
					MSAL.State AS SalonState,
					MSAL.Country AS SalonCountry,
					MSAL.Phone AS SalonPhone,
					MSAL.SalonFinderID,
					MSAL.IsMaster,
					DT.TerrLabel,
					DT.TerrCode,
					MSR.Relationship,
					MT.mbrTypeName,
					case when M.mbrTierID = 4 then dbo.udf_TitaniumGrandfatherLvl(M.mbrID) else null end as GrandfatheredTitanium
					, m.langUID
					, m.clientUID
					, m.emailConfirmedCanada
					, m.emailConfirmedDTM
					, m.optOutCanada
				FROM mbr M WITH(NOLOCK)
					LEFT JOIN mbrStatus MS WITH(NOLOCK) ON M.mbrStatusID = MS.mbrStatusID
					LEFT JOIN DiscountType DTY WITH(NOLOCK) ON M.DiscountTypeID = DTY.DiscountTypeID
					LEFT JOIN mbrType MT WITH(NOLOCK) ON M.mbrTypeID = MT.mbrTypeID
					LEFT JOIN Country C WITH(NOLOCK) ON M.Country = C.CountryName
					LEFT JOIN SecurityQuestion SQ WITH(NOLOCK) ON SQ.SecurityQuestionID = M.SecurityQuestionID
					LEFT JOIN view_mbrTransactionSummary VMTS WITH(NOLOCK) ON M.mbrID = VMTS.mbrID
					LEFT JOIN mbrTier MTI WITH(NOLOCK) ON M.mbrTierID = MTI.mbrTierID
					LEFT JOIN Distributor D WITH(NOLOCK) ON M.DistributorID = D.DistributorID
					LEFT JOIN DistributorTerr DT WITH(NOLOCK) ON M.DistributorTerrID = DT.DistributorTerrID
					LEFT JOIN mbrSalonRelationship MSR WITH(NOLOCK) ON M.mbrSalonRelationshipID = MSR.mbrSalonRelationshipID
					left join dbo.mbrSalon MSAL with(nolock) on M.mbrID = MSAL.mbrID and MSAL.IsActive = 1
				WHERE 1=1
					AND M.IsActive = 1
					AND M.clientUID = <cfqueryparam CFSQLType="cf_sql_varchar" value="#arguments.clientUID#">
					-- AND M.LastName LIKE 'smith%'
					AND M.mbrStatusID = 1
					<cfif arguments.mbrID>
						AND M.mbrID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#arguments.mbrID#">
					</cfif>
					<cfif arguments.tierID>
						AND M.mbrTierID = <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#arguments.tierID#">
					</cfif>
			) AS pagination
			WHERE RowNumber BETWEEN <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#startRecord#"> AND <cfqueryparam CFSQLType="CF_SQL_INTEGER" value="#endRecord#">
			ORDER BY mbrID
		</cfquery>

		<cfreturn qry>
	</cffunction>


	<cffunction name="getmbrExpiringPointsPagination" access="public" returntype="query">
		<cfargument name="lastName" type="string" required="no" default="" />
		<cfargument name="firstName" type="string" required="no" default="" />
		<cfargument name="email" type="string" required="no" default="" />
		<cfargument name="salonNameLike" type="string" required="no" default="" />
		<cfargument name="phone" type="string" required="no" default="" />
		<cfargument name="distributorAcctNumLike" type="string" required="no" default="" />
		<cfargument name="mbrID" type="string" required="no" default="" />
		<cfargument name="distributorID" type="string" required="no" default="" />
		<cfargument name="mbrStatusID" type="string" required="no" default="" />
		<cfargument name="matchType" type="string" required="no" default="Exact" />
		<cfargument name="maxRows" type="string" required="no"  default="500" />
		<cfargument name="orderBy" type="string" required="no"  default="M.FirstName, M.LastName" />
		<cfargument name="pageNumber" type="numeric" required="false" default="1" />
		<cfargument name="langUID" required="no" />
		<cfargument name="clientUID" required="no" />

		<cfset var qry = "" />
		<cfset var startRecord = ((arguments.pageNumber-1)*arguments.maxRows)+1 />
		<cfset var endRecord = (arguments.pageNumber*arguments.maxRows) />
		<cfset var mMatchTypePrefix = "" />
		<cfset var mMatchTypeSuffix = "" />

		<!--- Match Type Logic --->
		<cfif arguments.matchType EQ "Contains">
			<cfset mMatchTypePrefix = "%">
			<cfset mMatchTypeSuffix = "%">
		<cfelseif arguments.matchType EQ "Starts">
			<cfset mMatchTypeSuffix = "%">
		</cfif>

		<cfquery name="qry">
			declare @ExpirationDTM datetime
			set @ExpirationDTM = DATEADD(m, DATEDIFF(m, -1, current_timestamp), 0)

			declare @ExpirationDTM2 datetime
			set @ExpirationDTM2 = DATEADD(m,1,DATEADD(m, DATEDIFF(m, -1, current_timestamp), 0))

			declare @ExpirationDTM3 datetime
			set @ExpirationDTM3 = DATEADD(m,2,DATEADD(m, DATEDIFF(m, -1, current_timestamp), 0))

			SELECT RowNumber,
					TotalRows,
					CEILING(TotalRows/CAST(500 AS Decimal(10,2))) as TotalPage,
					mbrID,
					FirstName,
					LastName,
					EmailAddress,
					LastLogin,
					Address1,
					Address2,
					City,
					State,
					ZipCode,
					Country,
					Phone,
					DTMCreated,
					mbrStatusName,
					Nickname,
					mbrSalonID,
					SalonName,
					SalonAddress1,
					SalonAddress2,
					SalonCity,
					SalonState,
					SalonCountry,
					SalonPhone,
					SalonFinderID,
					langUID,
					clientUID,
					emailConfirmedCanada,
					emailConfirmedDTM,
					optOutCanada,
					ISNULL(ExpirationPoints,0) AS ExpirationPoints,
					ISNULL(ExpirationPoints2,0) AS ExpirationPoints2,
					ISNULL(ExpirationPoints3,0) AS ExpirationPoints3
			FROM (
					SELECT ROW_NUMBER() OVER (ORDER BY #arguments.orderBy#) AS RowNumber, Count(*) OVER() AS TotalRows,
						M.mbrID,
						M.FirstName,
						M.LastName,
						M.EmailAddress,
						M.LastLogin,
						M.Address1,
						M.Address2,
						M.City,
						M.State,
						M.ZipCode,
						M.Country,
						M.Phone,
						M.DTMCreated,
						MS.mbrStatusName,
						D.Nickname,
						MSAL.mbrSalonID,
						MSAL.SalonName,
						MSAL.Address1 AS SalonAddress1,
						MSAL.Address2 AS SalonAddress2,
						MSAL.City AS SalonCity,
						MSAL.State AS SalonState,
						MSAL.Country AS SalonCountry,
						MSAL.Phone AS SalonPhone,
						MSAL.SalonFinderID,
						MSAL.IsMaster,
						m.langUID,
						m.clientUID,
						m.emailConfirmedCanada,
						m.emailConfirmedDTM,
						m.optOutCanada
						,(
							select sum(isnull(Points,0) - isnull(ExpiredPoints,0) - isnull(PointsRedeemed,0)) as ExpirationPoints
							from dbo.mbrTransaction with(nolock)
							where mbrID = M.mbrID
								and IsActive = 1
								and ExpirationDTM = @ExpirationDTM
						) as ExpirationPoints
						,(
							select sum(isnull(Points,0) - isnull(ExpiredPoints,0) - isnull(PointsRedeemed,0)) as ExpirationPoints
							from dbo.mbrTransaction with(nolock)
							where mbrID = M.mbrID
								and IsActive = 1
								and ExpirationDTM = @ExpirationDTM2
						) as ExpirationPoints2
						,(
							select sum(isnull(Points,0) - isnull(ExpiredPoints,0) - isnull(PointsRedeemed,0)) as ExpirationPoints
							from dbo.mbrTransaction with(nolock)
							where mbrID = M.mbrID
								and IsActive = 1
								and ExpirationDTM = @ExpirationDTM3
						) as ExpirationPoints3
					FROM mbr M WITH(NOLOCK)
						LEFT JOIN mbrStatus MS WITH(NOLOCK) ON M.mbrStatusID = MS.mbrStatusID
						LEFT JOIN Distributor D WITH(NOLOCK) ON M.DistributorID = D.DistributorID
						OUTER APPLY (
							SELECT TOP 1
								mbrSalonID,
								SalonName,
								Address1,
								Address2,
								City,
								State,
								Country,
								Phone,
								SalonFinderID,
								IsMaster
							FROM mbrSalon WITH(NOLOCK)
							WHERE 1=1
								AND IsActive = 1
								AND mbrID = M.mbrID
							ORDER BY IsMaster desc

						) AS MSAL
					WHERE 1=1
						AND M.IsActive = 1

						<cfif structKeyExists(ARGUMENTS,"clientUID") AND len(trim(arguments.clientUID))>
							AND M.clientUID = <cfqueryparam value="#arguments.clientUID#" CFSQLType="CF_SQL_idstamp">
						</cfif>
						<cfif len(trim(arguments.emailLike))>
							AND M.EmailAddress LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.emailLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif IsNumeric(arguments.mbrIDLike)>
							AND M.mbrID LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.mbrIDLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.firstNameLike))>
							AND M.FirstName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.firstNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.lastNameLike))>
							AND M.LastName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.lastNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.phoneLike))>
							AND M.Phone LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.phoneLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
						</cfif>
						<cfif len(trim(arguments.salonNameLike))>
							AND M.mbrID IN (
													SELECT mbrID
													FROM mbrSalon WITH(NOLOCK)
													WHERE 1=1
														AND IsActive = 1
														AND SalonName LIKE <cfqueryparam value="#mMatchTypePrefix##arguments.salonNameLike##mMatchTypeSuffix#" CFSQLType="CF_SQL_VARCHAR">
											)
						</cfif>
						<cfif len(trim(arguments.distributorID))>
							<cfif arguments.distributorID EQ 0>
								AND D.DistributorID IS NULL
							<cfelse>
								AND D.DistributorID IN (<cfqueryparam value="#arguments.distributorID#" CFSQLType="CF_SQL_VARCHAR" list="true">)
							</cfif>
						</cfif>
						<cfif len(trim(arguments.mbrID))>
							AND M.mbrID = <cfqueryparam value="#arguments.mbrID#" CFSQLType="CF_SQL_INTEGER">
						</cfif>
						<cfif len(trim(arguments.mbrStatusID))>
							AND M.mbrStatusID = <cfqueryparam value="#arguments.mbrStatusID#" CFSQLType="CF_SQL_INTEGER">
						</cfif>
						<cfif len(trim(arguments.firstName))>
							AND M.FirstName = <cfqueryparam value="#arguments.firstName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
						</cfif>
						<cfif len(trim(arguments.lastName))>
							AND M.LastName = <cfqueryparam value="#arguments.lastName#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
						</cfif>
						<cfif len(trim(arguments.email))>
							AND M.EmailAddress = <cfqueryparam value="#arguments.email#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
						</cfif>
						<cfif len(trim(arguments.phone))>
							AND M.Phone = <cfqueryparam value="#arguments.phone#" CFSQLType="CF_SQL_VARCHAR" maxlength="500">
						</cfif>

			) AS pagination
			WHERE RowNumber BETWEEN <cfqueryparam value="#startRecord#" CFSQLType="CF_SQL_INTEGER"> AND <cfqueryparam value="#endRecord#" CFSQLType="CF_SQL_INTEGER">
			ORDER BY RowNumber
		</cfquery>

		<cfreturn qry>
	</cffunction>

</cfcomponent>
