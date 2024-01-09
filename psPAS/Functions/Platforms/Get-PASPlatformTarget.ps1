# .ExternalHelp psPAS-help.xml
function Get-PASPlatformTarget {
	[CmdletBinding(DefaultParameterSetName = 'targets')]
	param(
        [parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'target-details'
		)]
		[boolean]$ID,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'targets'
		)]
		[boolean]$Active,


		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'targets'
		)]
		[string]$SystemType,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'targets'
		)]
		[boolean]$PeriodicVerify,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'targets'
		)]
		[boolean]$ManualVerify,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'targets'
		)]
		[boolean]$PeriodicChange,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'targets'
		)]
		[boolean]$ManualChange,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'targets'
		)]
		[boolean]$AutomaticReconcile,

		[parameter(
			Mandatory = $false,
			ValueFromPipelinebyPropertyName = $true,
			ParameterSetName = 'targets'
		)]
		[boolean]$ManualReconcile

	)

	BEGIN {

	}#begin

	PROCESS {

        switch ($PSCmdlet.ParameterSetName) {

			'targets' {

				Assert-VersionRequirement -RequiredVersion 11.4

				$URI = "$Script:BaseURI/API/Platforms/$($PSCmdlet.ParameterSetName)"

				#Get Parameters to include in request
				$boundParameters = $PSBoundParameters | Get-PASParameter

				$queryString = $boundParameters | ConvertTo-FilterString | ConvertTo-QueryString

				If ($null -ne $queryString) {

					$URI = "$URI`?$queryString"

				}

				break

			}

            'target-details' {

				Assert-VersionRequirement -RequiredVersion 11.4

				$URI = "$Script:BaseURI/API/Platforms/targets/$ID"

				break

			}

		}

		#Send request to web service
		$result = Invoke-PASRestMethod -Uri $URI -Method GET -WebSession $Script:WebSession

		If ($null -ne $result) {

			#11.1+ returns result under "platforms" property
			If ($result.Platforms) {

				$result = $result | Select-Object -ExpandProperty Platforms

                $result = $result |
                    Select-Object PlatformID, Active, @{ Name = 'Details'; Expression = { [pscustomobject]@{
                                'ID'                          = $_.ID
                                'Name'                        = $_.Name
                                'SystemType'                  = $_.SystemType
                                'AllowedSafes'                = $_.AllowedSafes
                                'CredentialsManagementPolicy' = $_.CredentialsManagementPolicy
                                'PrivilegedAccessWorkflows'   = $_.PrivilegedAccessWorkflows
                                'PrivilegedSessionManagement' = $_.PrivilegedSessionManagement
                            }
                        }
                    }

			}

			#Return Results
			$result |

				Add-ObjectDetail -typename 'psPAS.CyberArk.Vault.Platform'

		}

	}#process

	END { }#end

}
