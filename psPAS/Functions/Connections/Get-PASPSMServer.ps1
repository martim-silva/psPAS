# .ExternalHelp psPAS-help.xml
Function Get-PASPSMServer {
	[CmdletBinding()]
	param (
        [Parameter(Mandatory=$false)]
        [string]$Search
    )

	BEGIN {

	}#begin

	PROCESS {

        Assert-VersionRequirement -RequiredVersion 11.5

		$URI = "$Script:BaseURI/API/psm/servers"

		#Send request to web service
		$result = Invoke-PASRestMethod -Uri $URI -Method GET -WebSession $Script:WebSession

		If ($null -ne $result) {

			#11.1+ returns result under "platforms" property
			If ($result.PSMServers) {

				$result = $result | Select-Object -ExpandProperty PSMServers
			}

			if ($PSBoundParameters.ContainsKey('Search')) {
				$result = $result | Where-Object { $_.Name -like "*$Search*" -or $_.DisplayName -like "*$Search*" }
			}
            $result = $result | Select-Object @{Name='Id'; Expression={$_.ID}}, @{Name='Name'; Expression={$_.Name}}, @{Name='IsLoadBalancer'; Expression={If ($_.Address -like "*bmwgroup.net") {$true} Else {$false}}}, @{Name='Address'; Expression={$_.Address}}
		}

			#Return Results
			$result | Add-ObjectDetail -typename 'psPAS.CyberArk.Vault.PSMServer'



	}#process

	END { }#end

}