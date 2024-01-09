# .ExternalHelp psPAS-help.xml
Function Get-PASConnectionComponent {
	[CmdletBinding()]
	param (
        [Parameter(Mandatory=$false)]
        [string]$Search
    )

	BEGIN {

	}#begin

	PROCESS {

        Assert-VersionRequirement -RequiredVersion 11.4

		$URI = "$Script:BaseURI/API/psm/connectors"

		#Send request to web service
		$result = Invoke-PASRestMethod -Uri $URI -Method GET -WebSession $Script:WebSession

		If ($null -ne $result) {

			#11.1+ returns result under "platforms" property
			If ($result.PSMConnectors) {

				$result = $result | Select-Object -ExpandProperty PSMConnectors
				$result = $result | Select-Object @{Name='Id'; Expression={$_.ID}}, @{Name='DisplayName'; Expression={$_.DisplayName}}
			}

			if ($PSBoundParameters.ContainsKey('Search')) {
				$result = $result | Where-Object { $_.Name -like "*$Search*" -or $_.DisplayName -like "*$Search*" }
			}

			#Return Results
			$result |

				Add-ObjectDetail -typename 'psPAS.CyberArk.Vault.ConnectionComponent'

		}

	}#process

	END { }#end

}