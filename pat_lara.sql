SELECT 
	ppAcreageSpec.AcreageSpecID
	,tblCounties.Cs_Name AS County
	,Crop.Name AS Crop
	,ppFormType.FormAbbrev AS Form
	,ppAcreageSpec.SecNo AS Sect
	,[TownshipRange].[township]+"-"+[townshiprange].[range] AS [Twp/Rng]
	,ppAcreageSpec.FSNNo AS FSN
	,ppAcreageSpec.FarmName
	,ppAcreageSpec.Acres
	,Format([SharePercent],"Percent") AS Share
	,ppAcreageSpec.Yield
	,ppAcreageSpec.CoveragePerAcre AS Coverage
	,ppAcreageSpec.LOI
	,ppAcreageSpec.Premium
	,ppAcreageSpec.Excluded
	,Switch([NewLand]=True,"Yes",[newland]<>True,"") AS IsNewLand
	,ppAcreageSpec.MPacreageID
	,ppCoverageSpec.EndDate
	,ppAcreageSpec.EndDate
	,ppPolicy.PolicyId
	,ppCoverageSpec.CoverageSpecId
	,ppCoverageSpec.CoverageId 
FROM 
ppPolicy 
INNER JOIN 
	(
		(
			(
			tblCounties 
			INNER JOIN 
				(
				Crop 
				INNER JOIN 
				ppCoverage 
				ON Crop.CropId = ppCoverage.CropId
				) 
			ON tblCounties.Cs_ID = ppCoverage.CountyId
			) 
		INNER JOIN 
			(
					ppAcreage 
			INNER JOIN 
					(
					ppAcreageSpec 
					LEFT JOIN 
					TownshipRange 
					ON ppAcreageSpec.TownshipRangeId = TownshipRange.TownshipRangeId
					) 
					ON ppAcreage.AcreageId = ppAcreageSpec.AcreageId
			) 
			ON ppCoverage.CoverageID = ppAcreage.CoverageId
		) 
		INNER JOIN 
			(
			ppCoverageSpec 
			INNER JOIN 
			ppFormType 
			ON ppCoverageSpec.FormTypeId = ppFormType.FormTypeId
			) 
		ON ppCoverage.CoverageID = ppCoverageSpec.CoverageId
	) 
ON ppPolicy.PolicyId = ppCoverage.PolicyId


WHERE 
(
	(
		(
		ppCoverageSpec.EndDate
		) Is Null
	) 
	AND 
	(
		(
		ppAcreageSpec.EndDate
		) Is Null
	) 
	AND
	(
		(
		ppPolicy.PolicyId
		)=[Forms]![frmViewPolicy]![PolicyId]
	)
) 
ORDER BY tblCounties.Cs_Name, Crop.Name, ppAcreageSpec.Excluded DESC;